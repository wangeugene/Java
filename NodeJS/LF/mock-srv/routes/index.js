"use strict";

export default async function (fastify) {
    fastify.get("/", async function (request, reply) {
        {
            return {
                name: "Mock Server Path from the Routes folder",
            };
        }
    });
}
