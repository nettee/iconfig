import path from "node:path"

export const NotificationPlugin = async ({ project, $, directory }) => {
  const projectName = project?.name?.trim()
  const dirName = path.basename(directory)
  const title = projectName || `opencode · ${dirName}`

  const notify = async ({ subtitle, message }) => {
    try {
      await $`cmux notify --title ${title} --subtitle ${subtitle} --body ${message}`
      return
    } catch {}

    await $`osascript -e '
      on run argv
        display notification (item 1 of argv) with title (item 2 of argv) subtitle (item 3 of argv)
      end run
    ' ${message} ${title} ${subtitle}`
  }

  return {
    event: async ({ event }) => {
      if (event.type === "permission.asked") {
        await notify({
          subtitle: "Waiting for input",
          message: `Permission required · ${dirName}`,
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
