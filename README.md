### mhmVis
`mhmVis` is an R package to visualise mHM input and output files.
The main focus is to read, process and plot `netcdf` and `asc` files.
`mhmVis` tries to facilitate automated saving of publication-ready grahics.
E.g. from netcdf files, `vis_nc_film` creates an animated time series movie on a projected map.

This is work-in-heavy-progress and still subject to API changes.
It is planned to be linked with [mHMr](https://github.com/JBrenn/mHMr) one day.
Bug reports and feature requests are welcome as an 
[issue](https://github.com/brry/mhmVis/issues) or via email at <berry-b@gmx.de>.

### installation

Install dependencies ([instructions](https://github.com/brry/OSMscale#intro) 
in case `OSMscale` does not install out of the box):
```R
install.packages("berryFunctions")
install.packages("OSMscale")
library(OSMscale)
```

Update dependencies and install `mhmVis` itself:
```R
berryFunctions::instGit("brry/berryFunctions")
berryFunctions::instGit("brry/OSMscale")
berryFunctions::instGit("brry/mhmVis")
```

### usage

Examples to be added


## mHM installation

### Step 1: Set up virtual machine with linux ubuntu

My favorite way of working with mHM on a windows machine. Install [VMware](https://www.vmware.com/products/player/playerpro-evaluation.html) and download an [Ubuntu ISO file](https://www.ubuntu.com/download/desktop).

VMware - New virtual Machine - select iso from disc  
Settings:  
- more RAM space  
- more Cores  

Optional, but recommended: Create a 
[shared folder](https://www.vmware.com/support/ws5/doc/ws_running_shared_folders.html) 
(in another location than where virtual machine is stored).

### Step 2: Install MHM with dependencies

This is an instruction for Ubuntu 16.04 (GNU compilers as per default) for mHM 5.6 from dec 2016, updated in July 2017, 
by Berry Boessenkool, Uni Potsdam, <berry-b@gmx.de>.

In the virtual Linux, you may need to configure to a German keyboard in the terminal (CTRL + ALT + T):  
`sudo dpkg-reconfigure keyboard-configuration`

For completeness, here's a link to the [official netcdf documentation](http://www.unidata.ucar.edu/software/netcdf/docs/getting_and_building_netcdf.html).

Download the five dependencies 

* [CURL](https://curl.haxx.se/download.html), otherwise you may run into the errors: `/usr/bin/ld: cannot find -lsz` and`/usr/bin/ld: cannot find -lcurl`, even though `whereis curl` returns curl: /usr/bin/curl /
* [zlib](http://www.zlib.net/) - zlib source code, version 1.2.10, tar.gz format 593K -  US (zlib.net) 
* [hdf5](https://support.hdfgroup.org/downloads/)
* [netcdf-c](https://github.com/Unidata/netcdf-c/releases) and [netcdf-fortran](https://github.com/Unidata/netcdf-fortran/releases) or from [Unidata](http://www.unidata.ucar.edu/downloads/netcdf/index.jsp) - the Latest Stable netCDF-[C/Fortran] Release, tar.gz

and unzip them to some folder (not the place where you will install them).
The version numbers below may of course be different from yours by now.

If you're working on a windows PC with Ubuntu on a virtual machine with VMware, you should not install in the shared folder.
The hdf5 'make' and 'make check' take several minutes. 
'make' before 'make check' was not necessary on native linux, only on the virtual machine.
The `>&` routes the output along with any errors into a file, thus saving it for later reference 
(and keeping the terminal clean of 19k lines of output). 
You can open the files quickly with e.g. `gedit make.out`.

If you close the terminal inbetween, please redefine PROGDIR at the beginning of the next session!
If you use another program directory than the /usr/local folder, 
you should [find out](https://curl.haxx.se/docs/install.html) how to pass it to curl.

```bash
berry@berry-E8420:~/Documents$

sudo apt install m4
gfortran --version 
sudo apt install gfortran
gcc --version   # --> 5.4.0 

PROGDIR=/usr/local

cd ../curl-7.52.1
./configure
make >& make.out
make test >& maketest.out
sudo make install >& makeinstall.out
gedit makeinstall.out # to check for errors (after each step below as well)

cd zlib-1.2.11
./configure --prefix=${PROGDIR}
make check >& makecheck.out
sudo make install >& makeinstall.out

cd ../hdf5-1.8.18
./configure --with-zlib=${PROGDIR} --prefix=${PROGDIR}
make >& make.out
make check >& makecheck.out
sudo make install >& makeinstall.out

cd ../netcdf-4.4.1.1
LD_LIBRARY_PATH=/usr/local/lib
CPPFLAGS=-I${PROGDIR}/include LDFLAGS=-L${PROGDIR}/lib ./configure --prefix=${PROGDIR}
make >& make.out
make check >& makecheck.out
sudo make install >& makeinstall.out

cd ../netcdf-fortran-4.4.4
FC=gfortran CPPFLAGS=-I${PROGDIR}/include LDFLAGS=-L${PROGDIR}/lib ./configure --prefix=/usr/local/netcdf_4.4_gfortran54
make check >& makecheck.out
sudo make install >& makeinstall.out
```

If you have made it this far without errors, please celebrate. ;-)

Now that all the dependencies are installed, you can configure and install mHM.
In `my_mHM_folder/make.config`, along with [berry.alias](https://github.com/brry/mhmVis/blob/master/inst/extdata/berry.alias),
I have the [berry.gnu54](https://github.com/brry/mhmVis/blob/master/inst/extdata/berry.gnu54) file with
```
# Paths
GNUDIR := /usr
GNULIB := $(GNUDIR)/lib
GNUBIN := $(GNUDIR)/bin

# NETCDF
SZLIB   := /usr/local/lib
HDF5LIB := /usr/local/lib
NCDIR   := /usr/local
NCFDIR  := /usr/local/netcdf_4.4_gfortran54
CURLLIB := /usr/bin
```
You may have to change `SZLIB` to `ZLIB`, but that is currently untested. Probably try having both...
Don't forget to tell the `my_mHM_folder/Makefile` which configuration file to use:
```
system   := berry
compiler := gnu54
```

To finally actually install mHM:
```bash
cd ../mHM_v5.6/
make >& make.out
make clean >& makeclean.out # to be run after errors
```

Here's my proposed workflow:

Create a folder with all the input and output data for a project in the VMware shared folder 
(if you also want to access it from windows).
Or in some other place where it fits the structure of your work.

Then copy the mhm executable file to that place, so that you have the software creation separate from it's usage.
That will allow you to easily create other builds of mHM (for example, with parallel computing enabled) and keep a good overview of those builds.

