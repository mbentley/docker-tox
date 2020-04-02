# mbentley/tox

docker image for [tox](https://tox.readthedocs.io/en/latest/)
based off of ubuntu:18.04

To pull this image:
`docker pull mbentley/tox`

Example usage:

1. Make sure `${HOME}/.cache` and `${HOME}/.local` exist:

    ```
    mkdir ${HOME}/.cache ${HOME}/.local
    ```

1. Run tox:

    _Note:_ Before running tox, make sure that you have bind mounts for all of the necessary files, such as your `.gitconfig`, `.ssh`, `.cache` files and directories; whatever you'll need in the container.

    ```
    docker run -it --rm \
      --name tox \
      -e MY_USERNAME="${USER}" \
      -e MY_UID="$(id -u)" \
      -e MY_GID="$(id -g)" \
      --tmpfs /tmp \
      --tmpfs /var/log \
      -v "${HOME}/.cache":/home/"${USER}/.cache" \
      -v "${HOME}/.gitconfig":"/home/${USER}/.gitconfig":ro \
      -v "${HOME}/.local":"/home/${USER}/.local" \
      -v "${HOME}/.ssh":/home/"${USER}/.ssh":ro \
      -v "${PWD}":/data \
      -w /data \
      mbentley/tox \
        tox --help
    ```

    Or if you do not want tox to store files in your home directory, you can use docker volumes:

    ```
    docker run -it --rm \
      --name tox \
      -e MY_USERNAME="${USER}" \
      -e MY_UID="$(id -u)" \
      -e MY_GID="$(id -g)" \
      --tmpfs /tmp \
      --tmpfs /var/log \
      -v tox-cache:/home/"${USER}/.cache" \
      -v tox-local:"/home/${USER}/.local" \
      -v "${HOME}/.gitconfig":"/home/${USER}/.gitconfig":ro \
      -v "${HOME}/.ssh":/home/"${USER}/.ssh":ro \
      -v "${PWD}":/data \
      -w /data \
      mbentley/tox \
        tox --help
     ```

If you wish to run tox and have it appear to run as if it is natively installed and work by just calling `tox`, create a bash function and add it to your `~/.bashrc`:

```bash
tox() {
  docker run -it --rm \
    --name tox \
    -e MY_USERNAME="${USER}" \
    -e MY_UID="$(id -u)" \
    -e MY_GID="$(id -g)" \
    --tmpfs /tmp \
    --tmpfs /var/log \
    -v tox-cache:/home/"${USER}/.cache" \
    -v tox-local:"/home/${USER}/.local" \
    -v "${HOME}/.gitconfig":"/home/${USER}/.gitconfig":ro \
    -v "${HOME}/.ssh":/home/"${USER}/.ssh":ro \
    -v "${PWD}":/data \
    -w /data \
    mbentley/tox \
      tox ${@}
}
```
