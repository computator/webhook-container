FROM docker.io/library/ubuntu

LABEL org.opencontainers.image.source=https://github.com/computator/webhook-container

ARG RELEASE_VER=latest

RUN set -eux; \
	apt-get update; \
	apt-get -y install --no-install-recommends curl ca-certificates; \
	SOURCE_URL=$(\
		curl -sSH 'X-GitHub-API-Version: 2022-11-28' \
				"https://api.github.com/repos/adnanh/webhook/releases/$([ "$RELEASE_VER" = "latest" ] || echo "tags/")${RELEASE_VER}" \
			| grep -e 'browser_download_url.*linux-amd64' \
			| cut -d '"' -f 4\
		); \
	curl -L $SOURCE_URL | tar -xzO > /usr/bin/webhook; \
	chmod 755 /usr/bin/webhook; \
	rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["webhook"]
