# mbentley/tox

docker image for [tox](https://tox.readthedocs.io/en/latest/)
based off of ubuntu:18.04

To pull this image:
`docker pull mbentley/tox`

Example usage:

```
docker run -it --rm \
  --name tox \
  -e MY_USERNAME="${USER}" \
  -e MY_UID="$(id -u)" \
  -e MY_GID="$(id -g)" \
  --tmpfs /tmp \
  -v "${HOME}/.gitconfig":"/home/${USER}/.gitconfig" \
  -v "${HOME}/.ssh":/home/"${USER}/.ssh" \
  -v "${HOME}/.cache/pip":/home/"${USER}/.cache/pip" \
  -v "${PWD}":/data \
  -w /data \
  mbentley/tox \
    tox --help
```
