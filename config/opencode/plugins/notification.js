import path from "node:path"

export const NotificationPlugin = async ({ project, $, directory }) => {
  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        const projectName = project?.name?.trim()
        const dirName = path.basename(directory)
        const title = projectName || `opencode · ${dirName}`
        const subtitle = projectName ? dirName : "session.idle"
        const message = `Session completed · ${dirName}`

        await $`osascript -e '
          on run argv
            display notification (item 1 of argv) with title (item 2 of argv) subtitle (item 3 of argv)
          end run
        ' ${message} ${title} ${subtitle}`
      }
    },
  }
}
