FROM nginx

# Install wget
RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

# Install unzip
RUN apt-get update && apt-get install -y unzip

# Download & install the OneAgent
ARG DT_API_URL="https://<environmentID>.live.dynatrace.com/api"
ARG DT_API_TOKEN="<token>"
ARG DT_ONEAGENT_OPTIONS="flavor=default&include=<technology1>&include=<technology2>"
ENV DT_HOME="/opt/dynatrace/oneagent"
RUN mkdir -p "$DT_HOME" && \
    wget -O "$DT_HOME/oneagent.zip" "$DT_API_URL/v1/deployment/installer/agent/unix/paas/latest?Api-Token=$DT_API_TOKEN&$DT_ONEAGENT_OPTIONS" && \
    unzip -d "$DT_HOME" "$DT_HOME/oneagent.zip" && \
    rm "$DT_HOME/oneagent.zip"
ENTRYPOINT [ "/opt/dynatrace/oneagent/dynatrace-agent64.sh" ]

# Deploy the nginx example
COPY /src/html /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]
