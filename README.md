# mbentley/tox

docker image for [tox](https://tox.readthedocs.io/en/latest/)
based off of ubuntu:18.04

To pull this image:
`docker pull mbentley/tox`

Example usage:

1. Make sure `${HOME}/.cache/pip` exists:

    ```
    mkdir -p ${HOME}/.cache/pip
    ```

1. Run tox:

    _Note:_ Before running tox, make sure that you have bind mounts for all of the necessary files like your `.gitconfig`, `.ssh`, `.cache` files and directories; whatever you'll need in the container.

    ```
    docker run -it --rm \
      --name tox \
      -e MY_USERNAME="${USER}" \
      -e MY_UID="$(id -u)" \
      -e MY_GID="$(id -g)" \
      --tmpfs /tmp \
      -v "${HOME}/.cache/pip":/home/"${USER}/.cache/pip" \
      -v "${HOME}/.gitconfig":"/home/${USER}/.gitconfig" \
      -v "${HOME}/.ssh":/home/"${USER}/.ssh" \
      -v "${PWD}":/data \
      -w /data \
      mbentley/tox \
        tox --help
    ```
