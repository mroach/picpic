## Installing OpeCV in production

### Dependencies

```bash
apt-get install build-essential cmake
apt-get install zlib1g-dev libjpeg-dev libwebp-dev libpng-dev libtiff5-dev libjasper-dev libopenexr-dev libgdal-dev
```

### Building OpenCV

This configuration is attempting to be as minimalistic as possible to just do
simple Haar cascades for face detection from photos. Keeping it simple.

```bash
mkdir build

cd build

cmake -DWITH_QT=OFF -DWITH_GSTREAMER=OFF -DWITH_XIMEA=OFF -DWITH_GTK=OFF -DWITH_OPENGL=OFF -DFORCE_VTK=OFF -DWITH_TBB=OFF -DWITH_GDAL=OFF -DWITH_XINE=OFF -DBUILD_EXAMPLES=OFF -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_opencv_video=OFF -DDBUILD_opencv_ts=OFF -DBUILD_JASPER=OFF -DWITH_FFMPEG=OFF -DWITH_1394=OFF -DBUILD_opencv_highgui=OFF -DBUILD_opencv_calib3d=OFF

make -j4

make install

ldconfig
```
