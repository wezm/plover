To build the Xcode project you will need to do the following from the
`plover/osx/Plover` directory:

```
virtualenv virtualenv
. virtualenv/bin/activate
pip install appdirs pyserial simplejson Cython mock pyobjc-core pyobjc-framework-Cocoa pyobjc-framework-Quartz
git clone --recursive https://github.com/qdot/cython-hidapi
cd cython-hidapi
python setup-mac.py install
```
