# gcvideo-build-system

This should make it easier to build the gcvideo_dvi binaries needed for flashing from source.
[Docker](https://www.docker.com/) is used to actually do this.

#### STEP 0

Install [docker](https://docs.docker.com/install/).

#### STEP 1

Use the pre-build docker images available from my docker registry.
In order to that, you have to log in to the registry:
<br>*!!! This works for Linux/OSX and Windows. !!!*
```
docker login -u kalleblomquist docker.i74.de:5000
```
__*Contact me for the password!*__

--- **OR** ---

Build the docker images from stretch
<br>(see [chriz2600/xilinx-ise](https://github.com/chriz2600/xilinx-ise) for details on building xilinx-ise)
<br>*!!! This ONLY works for linux at the moment !!!*
```
# clone the docker build repositories
git clone https://github.com/chriz2600/xilinx-ise.git
git clone https://github.com/chriz2600/gcvideo-build-system.git

# copy installer files
cp ~/Downloads/Xilinx_ISE_DS_14.7_1015_* xilinx-installer/

# build xilinx-ise image
cd xilinx-ise
./build
# type n when asked to push the image

cd ..

# build gcvideo-build-system image
cd gcvideo-build-system
./build
# type n when asked to push the image
```

#### STEP 2

To build gcvideo_dvi:

- **Linux / MacOSX:**
    
    Install licence once:
    ```
    # install Xilinx license
    mkdir -p $HOME/.Xilinx
    cp ~/Downloads/Xilinx.lic $HOME/.Xilinx/
    ```
    Clone from github:
    ```
    git clone https://github.com/ikorb/gcvideo.git
    ```
    Build:
    ```
    cd gcvideo
    docker run --rm -it \
        -v $HOME/.Xilinx/Xilinx.lic:/root/.Xilinx/Xilinx.lic \
        -v $(pwd):/build \
        docker.i74.de:5000/gcvideo-build-system:latest \
        /usr/local/bin/wrapper bash -c "cd HDL/gcvideo_dvi/ && ./build-all.sh"
    ```

- **Windows Power Shell:**

    Setup git and install licence once:
    ```
    # ensure proper line endings
    git config --global core.autocrlf false

    # install Xilinx license
    mkdir C:\.Xilinx
    cp ~\Downloads\Xilinx.lic C:\.Xilinx
    ```
    Clone from github:
    ```
    git clone https://github.com/ikorb/gcvideo.git
    ```
    Build:
    ```
    cd gcvideo
    docker run -it --rm `
        -v C:\.Xilinx\Xilinx.lic:/root/.Xilinx/Xilinx.lic `
        -v ${pwd}:/build `
        docker.i74.de:5000/gcvideo-build-system:latest `
        /usr/local/bin/wrapper bash -c "cd HDL/gcvideo_dvi/ && ./build-all.sh"
    ```

#### STEP 3 optional autobuild setup

To run an automated build using gitlab, you have to set up a runner for this.
```
gitlab-runner register \
    -u https://gitlab.com/ \
    <registration_token> \
    --docker-image=docker.i74.de:5000/gcvideo-build-system:latest \
    --docker-volumes=$HOME/.Xilinx/Xilinx.lic:/root/.Xilinx/Xilinx.lic \
    --description="gcvideo" \
    --tag-list="gcvideo" \
    --executor=docker $*
```

*References:*
    
- [gcvideo .gitlab-ci.yml](https://github.com/chriz2600/gcvideo/blob/master/.gitlab-ci.yml) on how to set up autobuilds.
- [gcvideo pipelines](https://gitlab.com/chriz2600/gcvideo/pipelines) for automated builds.

---
