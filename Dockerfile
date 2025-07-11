ARG KEYCLOAK_VERSION=latest
ARG APPLE_PROVIDER_VERSION=1.10.0

FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION} as builder

ENV KC_HEALTH_ENABLED=true
ENV KC_FEATURES=token-exchange,admin-fine-grained-authz
ENV KC_DB=postgres
ENV KC_METRICS_ENABLED=true
ENV KC_HTTP_RELATIVE_PATH="/auth"

# Install Apple Identity Provider
ADD --chown=keycloak:keycloak https://github.com/klausbetz/apple-identity-provider-keycloak/releases/download/${APPLE_PROVIDER_VERSION}/apple-identity-provider-${APPLE_PROVIDER_VERSION}.jar /opt/keycloak/providers/apple-identity-provider-${APPLE_PROVIDER_VERSION}.jar

# Build optimized image
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}
COPY --from=builder /opt/keycloak/ /opt/keycloak/
WORKDIR /opt/keycloak
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]