# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
FROM ghcr.io/ublue-os/base-nvidia

USER root

RUN --mount=type=bind,from=ctx,source=/,target=/ctx,rw \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    chmod +x /ctx/*.sh && \
    #/ctx/waybar.sh && \
    #/ctx/foot.sh && \
    /ctx/build.sh && \
    /ctx/theme.sh && \
    /ctx/sddm.sh && \
    /ctx/river.sh && \
    ostree container commit

RUN bootc container lint
