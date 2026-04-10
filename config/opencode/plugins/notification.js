import path from "node:path"

export const NotificationPlugin = async ({ project, $, directory }) => {
  const projectName = project?.name?.trim()
  const dirName = path.basename(directory)
  const title = projectName || `opencode · ${dirName}`

  const notify = async ({ subtitle, message }) => {
    await $`cmux notify --title ${title} --subtitle ${subtitle} --body ${message}`
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
