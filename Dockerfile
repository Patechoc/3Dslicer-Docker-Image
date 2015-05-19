FROM ubuntu:14.04
MAINTAINER Patrick Merlot <patrick.merlot@gmail.com>

# Following instruction from http://www.slicer.org/slicerWiki/index.php/Documentation/Nightly/Developers/Build_Instructions

# INSTALL DEPENDENCIES
RUN apt-get update
RUN apt-get install -y \
    build-essential \
    python \
    python-dev \
    python-pip \
    python-virtualenv
    wget \
RUN apt-get install -y \
    gcc \
    git-core \
    git-svn \
    g++ \
    libfontconfig-dev \
    libglu1-mesa-dev \
    libgl1-mesa-dev \
    libosmesa6-dev \
    libncurses5-dev qt-sdk \
    libX11-dev \
    libxrender-dev \
    libXt-dev \
    make \
    subversion

# STANDARD CMAKE
# For Ubuntu 12.04, 12.10, 13.04, and 14.04: You *MUST download
# and build the standard cmake from http://cmake.org/
# because the distributed version of cmake cannot be used to build slicer.
RUN apt-get install -y \
    openssl \
    libssl-dev
RUN mkdir -p Support
WORKDIR Support
ENV cmakePackage cmake-3.0.0
RUN apt-get install -y wget
RUN wget http://www.cmake.org/files/v3.0/$cmakePackage.tar.gz -v -O $cmakePackage.tar.gz
RUN tar -xzvf $cmakePackage.tar.gz
WORKDIR cmake-3.0.0
RUN echo `pwd`
RUN apt-get install -y cmake
RUN cmake -DCMAKE_USE_OPENSSL:BOOL=ON
RUN make -j4
RUN for tool in cmake ccmake ctest cpack; do sudo ln -s ~/Support/$cmakePackage/bin/$tool /usr/local/bin/$tool; done

# CHECKOUT SLICER SOURCE FILES
RUN mkdir -p /myProject
WORKDIR /myProject
## Clone the github repository from public source here
## (also possible from a private Git repository. See https://mail.google.com/mail/u/0/#inbox/14d6b6bab0bc533e)
RUN apt-get install -y git git-core git-svn
RUN git clone --progress --verbose https://github.com/Slicer/Slicer.git
#RUN git clone --progress --verbose https://patrick_merlot@bitbucket.org/patrick_merlot/3dslicer-extension.git
## Setup the development environment
WORKDIR Slicer
RUN ./Utilities/SetupForDevelopment.sh
## Configure the git svn bridge to ensure the mapping with svn revision
RUN git svn init http://svn.slicer.org/Slicer4/trunk
RUN git update-ref refs/remotes/git-svn refs/remotes/origin/master
RUN git checkout master
RUN git svn rebase

# CONFIGURE AND GENERATE SLICER SOLUTION FILES
# (By default CMAKE_BUILD_TYPE is set to Debug)
RUN echo `pwd`
RUN mkdir -p Slicer-SuperBuild-Debug
WORKDIR Slicer-SuperBuild-Debug
RUN echo `pwd`
RUN apt-get install -y \
    qt5-qmake \
    qt-sdk \
    subversion
#RUN cmake -DCMAKE_BUILD_TYPE:STRING=Debug -DQT_QMAKE_EXECUTABLE:FILEPATH=/path/to/QtSDK/Desktop/Qt/486/gcc/bin/qmake ../Slicer
RUN cmake -DCMAKE_BUILD_TYPE:STRING=Debug -DQT_QMAKE_EXECUTABLE:FILEPATH=/usr/bin/qmake -qt=qt5 ../

# BUILD SLICER
RUN echo `pwd`
RUN apt-get install -y \
    python-dev \
    libxt-dev
RUN make -j2
#RUN make

# # RUN Slicer
# RUN echo `pwd`
# RUN ls
# CMD Slicer

# # PACKAGE SLICER
# RUN echo `pwd`
# #WORKDIR /myProject/Slicer/Slicer-SuperBuild-Debug
# RUN make package

# EXTENSIONS
# https://www.slicer.org/slicerWiki/index.php/Documentation/Nightly/Developers/Tutorials/BuildTestPackageDistributeExtensions

# TESTING FRAMEWORK
## https://www.slicer.org/slicerWiki/index.php/Documentation/Nightly/Developers/QtTesting
## https://www.slicer.org/slicerWiki/index.php/Documentation/Nightly/Developers/Tutorials/SelfTestModule
## https://www.slicer.org/slicerWiki/index.php/Documentation/Nightly/Developers/Tutorials/DashboardSetup