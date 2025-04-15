# Concept

There are many types of deployment strategies in Kubernetes, including:

-   **Big Bang Deployment**: This strategy involves deploying the entire application at once, which can be risky and lead to downtime if not managed properly.
-   **Blue-Green Deployment**: This strategy involves maintaining two identical environments, one for the current version (blue) and one for the new version (green). The traffic is switched from blue to green once the new version is ready.
-   **Rolling Update**: This strategy gradually replaces instances of the previous version with the new version, ensuring that some instances are always available.
-   **Canary Deployment**: This strategy involves deploying the new version to a small subset of users before rolling it out to the entire user base. This allows for testing in a production environment with minimal risk.
-   **Progressive Deployment**: This strategy is a combination of canary and blue-green deployments, where the new version is gradually rolled out to a larger subset of users over time, allowing for monitoring and rollback if necessary.
-   **A/B Testing**: This strategy involves deploying two versions of the application simultaneously to different user groups to compare performance and user experience.
-   **Shadow Deployment**: This strategy involves deploying the new version alongside the old version, but only sending a copy of the traffic to the new version for testing purposes.
-   **Feature Toggles**: This strategy involves deploying new features in a dormant state, allowing for testing and gradual rollout without affecting the entire application.
-   **Dark Launching**: This strategy involves deploying new features to production without exposing them to users, allowing for testing and monitoring before full rollout.
-   **Shadow Traffic**: This strategy involves sending a copy of production traffic to a new version of the application for testing and monitoring without affecting the user experience.

## The difference between progressive deployment and canary deployment

Progressive deployment is a broader term that encompasses various deployment strategies, including canary deployment. While canary deployment focuses on gradually rolling out a new version to a small subset of users, progressive deployment involves a more comprehensive approach that includes monitoring, rollback, and gradual rollout to larger user groups over time. Progressive deployment can include canary deployments as part of its strategy, but it also incorporates other techniques such as blue-green deployments and feature toggles.

## Tri-deployment approach

-   Primary - the primary variant that services 100% of your application traffic when Progressive Deployment is not executing.
-   Baseline - a clone of the primary (current) variant that serves as a baseline for comparison during Progressive Deployment execution.
-   Canary - the candidate application version, which is compared against the baseline variant during Progressive Deployment execution.

These 3 variants are live application instances.

-   Template - The template is not a live application instance. It is a blueprint for creating the baseline and canary variants. The template is used to create the baseline and canary variants, which are then deployed to the Kubernetes cluster.

0. Template is a clone of the primary variant.
1. Baseline is created from the template and is a clone of the primary variant. (The same version as Primary)
2. Canary is created from the template and is a clone of the primary variant. (The newer version than Primary)

## Judgement types:

Progressive Deployment currently supports the following judgement types:

-   Automated - Progressive Deployment execution pauses whilst the automatic analysis is performed, which compares application metrics and either approves or rejects based on thresholds defined. Rejection results in an instant pre-promotion rollback; approval results in resumed execution.
-   Manual - Progressive Deployment execution pauses whilst the application owner compares indicators and either approves or rejects via the Spinnaker UI. Rejection results in an instant rollback.
-   Bypass - Progressive Deployment does not pause execution and automatically progresses after each traffic shifting stage and associated bake period. The application owner must cancel the pipeline to roll back. (Deprecated)

## Instant rollback

During Progressive Deployment execution, an instant rollback to the current application version can be performed upon:

-   A negative judgement outcome.
-   Cancellation of the Spinnaker pipeline Progressive Deployment stage.
-   An error during Progressive Deployment execution.

## Post-promotion rollback

If things go wrong after successfully concluding a Progressive Deployment execution (i.e. that results in the promotion of a new application version), you can quickly roll back to a previous known-good application version (deployed through the same pipeline) via an additional Spinnaker stage that bypasses Progressive Deployment entirely.
