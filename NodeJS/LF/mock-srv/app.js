import path from 'node:path'
import { fileURLToPath } from 'node:url'
import AutoLoad from '@fastify/autoload'
import cors from '@fastify/cors'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

// Pass --options via CLI arguments in command to enable these options.
export const options = {}

export default async function (fastify, opts) {
  // This will ensure that the same Access-Control-Allow-Origin HTTP header that we manually set in the last section will be added for every route we create.
  fastify.register(cors)
  // Do not touch the following lines

  // This loads all plugins defined in plugins
  // those should be support plugins that are reused
  // through your application
  fastify.register(AutoLoad, {
    dir: path.join(__dirname, 'plugins'),
    options: Object.assign({}, opts),
  })

  // This loads all plugins defined in routes
  // define your routes in one of these
  fastify.register(AutoLoad, {
    dir: path.join(__dirname, 'routes'),
    options: Object.assign({}, opts),
  })
}
