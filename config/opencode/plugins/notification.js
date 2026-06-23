import path from "node:path"

export const NotificationPlugin = async ({ project, $, directory, client }) => {
  const projectName = project?.name?.trim()
  const dirName = path.basename(directory)
  const title = projectName || `opencode · ${dirName}`
  const rootSessionCache = new Map()
  const sessionStatusCache = new Map()

  const notify = async ({ subtitle, message }) => {
    try {
      await $`cmux notify --title ${title} --subtitle ${subtitle} --body ${message}`
    } catch {
      // cmux CLI may be unavailable in terminals launched outside cmux.
    }
  }

  const getSessionID = (event) => {
    return (
      event?.properties?.sessionID ||
      event?.properties?.sessionId ||
      event?.properties?.info?.id ||
      event?.sessionID ||
      event?.sessionId ||
      event?.session_id
    )
  }

  const getSessionInfo = (event) => {
    return event?.properties?.info || event?.info || event?.session
  }

  const getSessionParentID = (session) => {
    return (
      session?.parentID ||
      session?.parentId ||
      session?.parent_id ||
      session?.data?.parentID ||
      session?.data?.parentId ||
      session?.data?.parent_id
    )
  }

  const rememberSession = (event) => {
    const info = getSessionInfo(event)
    const sessionID = getSessionID(event) || info?.id

    if (!sessionID || !info) {
      return
    }

    rootSessionCache.set(sessionID, !getSessionParentID(info))
  }

  const getSessionStatusType = (event) => {
    const status = event?.properties?.status || event?.status
    return typeof status === "string" ? status : status?.type
  }

  const isRootSessionEvent = async (event) => {
    const sessionID = getSessionID(event)

    if (!sessionID) {
      return false
    }

    if (rootSessionCache.has(sessionID)) {
      return rootSessionCache.get(sessionID)
    }

    if (!client?.session?.get) {
      return false
    }

    try {
      const session = await client.session.get({
        path: { id: sessionID },
      })
      const isRoot = !getSessionParentID(session)
      rootSessionCache.set(sessionID, isRoot)
      return isRoot
    } catch (error) {
      console.warn("opencode notification: unable to resolve session parent", error)
      return false
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
      if (event.type === "session.created" || event.type === "session.updated") {
        rememberSession(event)
      }

      if (event.type === "session.status") {
        const sessionID = getSessionID(event)
        const status = getSessionStatusType(event)

        if (sessionID && status) {
          sessionStatusCache.set(sessionID, status)
        }
      }

      const isPromptEvent = promptEventTypes.has(event.type)
      const isSessionlessPromptEvent = isPromptEvent && !getSessionID(event)

      if (!isSessionlessPromptEvent && !(await isRootSessionEvent(event))) {
        return
      }

      if (isPromptEvent) {
        await notify({
          subtitle: "Waiting for input",
          message: getPromptMessage(event),
        })
      }

      if (event.type === "session.status" && getSessionStatusType(event) === "idle") {
        const sessionID = getSessionID(event)

        await new Promise((resolve) => setTimeout(resolve, 1500))

        if (sessionID && sessionStatusCache.get(sessionID) !== "idle") {
          return
        }

        await notify({
          subtitle: "Waiting for input",
          message: `Agent finished responding · ${dirName}`,
        })
      }

      if (event.type === "session.error") {
        await notify({
          subtitle: "Error",
          message: event.properties?.error?.message || `Session error · ${dirName}`,
        })
      }
    },
  }
}
