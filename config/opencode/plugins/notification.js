import path from "node:path"

export const NotificationPlugin = async ({ project, $, directory, client }) => {
  const projectName = project?.name?.trim()
  const dirName = path.basename(directory)
  const title = projectName || `opencode · ${dirName}`
  const rootSessionCache = new Map()

  const notify = async ({ subtitle, message }) => {
    await $`cmux notify --title ${title} --subtitle ${subtitle} --body ${message}`
  }

  const getSessionID = (event) => {
    return (
      event?.properties?.sessionID ||
      event?.properties?.info?.id ||
      event?.sessionID ||
      event?.session_id
    )
  }

  const isRootSessionEvent = async (event) => {
    const sessionID = getSessionID(event)

    if (!sessionID || !client?.session?.get) {
      return true
    }

    if (rootSessionCache.has(sessionID)) {
      return rootSessionCache.get(sessionID)
    }

    try {
      const session = await client.session.get({
        path: { id: sessionID },
      })
      const isRoot = !session?.data?.parentID
      rootSessionCache.set(sessionID, isRoot)
      return isRoot
    } catch {
      return true
    }
  }

  const promptEventTypes = new Set([
    "permission.asked",
    "question.asked",
    "tui.prompt.append",
  ])

  const getPromptMessage = (event) => {
    if (event.type === "permission.asked") {
      return `Permission required · ${dirName}`
    }

    return `Input required · ${dirName}`
  }

  return {
    event: async ({ event }) => {
      const isPromptEvent = promptEventTypes.has(event.type)

      if (!isPromptEvent && !(await isRootSessionEvent(event))) {
        return
      }

      if (isPromptEvent) {
        await notify({
          subtitle: "Waiting for input",
          message: getPromptMessage(event),
        })
      }

      if (event.type === "session.idle") {
        await notify({
          subtitle: "Waiting for input",
          message: `Agent finished responding · ${dirName}`,
        })
      }

      if (event.type === "session.error") {
        await notify({
          subtitle: "Error",
          message: event.error?.message || `Session error · ${dirName}`,
        })
      }
    },
  }
}
