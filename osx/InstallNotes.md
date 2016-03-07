brew install wxpython
sudo pip install virtualenv # Might be optional
sudo pip install --upgrade virtualenv
virtualenv ~/.virtualenv/plover
source ~/.virtualenv/plover/bin/activate

(Already had Xcode and Command Line Tools installed)

pip install appdirs pyserial simplejson py2app Cython mock pyobjc-core pyobjc-framework-Cocoa pyobjc-framework-Quartz wxversion

Collecting appdirs
  Downloading appdirs-1.4.0-py2.py3-none-any.whl
Collecting pyserial
  Downloading pyserial-2.7.tar.gz (122kB)
    100% |████████████████████████████████| 122kB 1.9MB/s
Collecting simplejson
  Downloading simplejson-3.8.0.tar.gz (75kB)
    100% |████████████████████████████████| 77kB 1.8MB/s
Collecting py2app
  Downloading py2app-0.9.tar.gz (1.7MB)
    100% |████████████████████████████████| 1.7MB 283kB/s
Collecting Cython
  Retrying (Retry(total=4, connect=None, read=None, redirect=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.python.org', port=443): Read timed out. (read timeout=15)",)': /packages/cp27/C/Cython/Cython-0.23.4-cp27-none-macosx_10_6_intel.macosx_10_9_intel.macosx_10_9_x86_64.macosx_10_10_intel.macosx_10_10_x86_64.whl
  Retrying (Retry(total=3, connect=None, read=None, redirect=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.python.org', port=443): Read timed out. (read timeout=15)",)': /packages/cp27/C/Cython/Cython-0.23.4-cp27-none-macosx_10_6_intel.macosx_10_9_intel.macosx_10_9_x86_64.macosx_10_10_intel.macosx_10_10_x86_64.whl
  Retrying (Retry(total=2, connect=None, read=None, redirect=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.python.org', port=443): Read timed out. (read timeout=15)",)': /packages/cp27/C/Cython/Cython-0.23.4-cp27-none-macosx_10_6_intel.macosx_10_9_intel.macosx_10_9_x86_64.macosx_10_10_intel.macosx_10_10_x86_64.whl
  Retrying (Retry(total=1, connect=None, read=None, redirect=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.python.org', port=443): Read timed out. (read timeout=15)",)': /packages/cp27/C/Cython/Cython-0.23.4-cp27-none-macosx_10_6_intel.macosx_10_9_intel.macosx_10_9_x86_64.macosx_10_10_intel.macosx_10_10_x86_64.whl
  Downloading Cython-0.23.4-cp27-none-macosx_10_6_intel.macosx_10_9_intel.macosx_10_9_x86_64.macosx_10_10_intel.macosx_10_10_x86_64.whl (3.6MB)
    100% |████████████████████████████████| 3.6MB 134kB/s
Collecting mock
  Downloading mock-1.3.0-py2.py3-none-any.whl (56kB)
    100% |████████████████████████████████| 57kB 2.5MB/s
Collecting pyobjc-core
  Downloading pyobjc-core-3.0.4.tar.gz (2.2MB)
    100% |████████████████████████████████| 2.2MB 223kB/s
Collecting pyobjc-framework-Cocoa
  Downloading pyobjc-framework-Cocoa-3.0.4.tar.gz (3.1MB)
    100% |████████████████████████████████| 3.1MB 152kB/s
Collecting pyobjc-framework-Quartz
  Retrying (Retry(total=4, connect=None, read=None, redirect=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.python.org', port=443): Read timed out. (read timeout=15)",)': /packages/source/p/pyobjc-framework-Quartz/pyobjc-framework-Quartz-3.0.4.tar.gz
  Retrying (Retry(total=3, connect=None, read=None, redirect=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.python.org', port=443): Read timed out. (read timeout=15)",)': /packages/source/p/pyobjc-framework-Quartz/pyobjc-framework-Quartz-3.0.4.tar.gz
  Retrying (Retry(total=2, connect=None, read=None, redirect=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.python.org', port=443): Read timed out. (read timeout=15)",)': /packages/source/p/pyobjc-framework-Quartz/pyobjc-framework-Quartz-3.0.4.tar.gz
  Retrying (Retry(total=1, connect=None, read=None, redirect=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.python.org', port=443): Read timed out. (read timeout=15)",)': /packages/source/p/pyobjc-framework-Quartz/pyobjc-framework-Quartz-3.0.4.tar.gz
  Retrying (Retry(total=0, connect=None, read=None, redirect=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.python.org', port=443): Read timed out. (read timeout=15)",)': /packages/source/p/pyobjc-framework-Quartz/pyobjc-framework-Quartz-3.0.4.tar.gz
Exception:
Traceback (most recent call last):
  File "/Users/wmoore/.virtualenv/plover/lib/python2.7/site-packages/pip/basecommand.py", line 211, in main
    status = self.run(options, args)
  File "/Users/wmoore/.virtualenv/plover/lib/python2.7/site-packages/pip/commands/install.py", line 305, in run
    wb.build(autobuilding=True)
  File "/Users/wmoore/.virtualenv/plover/lib/python2.7/site-packages/pip/wheel.py", line 705, in build
    self.requirement_set.prepare_files(self.finder)
  File "/Users/wmoore/.virtualenv/plover/lib/python2.7/site-packages/pip/req/req_set.py", line 334, in prepare_files
    functools.partial(self._prepare_file, finder))
  File "/Users/wmoore/.virtualenv/plover/lib/python2.7/site-packages/pip/req/req_set.py", line 321, in _walk_req_to_install
    more_reqs = handler(req_to_install)
  File "/Users/wmoore/.virtualenv/plover/lib/python2.7/site-packages/pip/req/req_set.py", line 491, in _prepare_file
    session=self.session)
  File "/Users/wmoore/.virtualenv/plover/lib/python2.7/site-packages/pip/download.py", line 825, in unpack_url
    session,
  File "/Users/wmoore/.virtualenv/plover/lib/python2.7/site-packages/pip/download.py", line 673, in unpack_http_url
    from_path, content_type = _download_http_url(link, session, temp_dir)
  File "/Users/wmoore/.virtualenv/plover/lib/python2.7/site-packages/pip/download.py", line 857, in _download_http_url
    stream=True,
  File "/Users/wmoore/.virtualenv/plover/lib/python2.7/site-packages/pip/_vendor/requests/sessions.py", line 477, in get
    return self.request('GET', url, **kwargs)
  File "/Users/wmoore/.virtualenv/plover/lib/python2.7/site-packages/pip/download.py", line 373, in request
    return super(PipSession, self).request(method, url, *args, **kwargs)
  File "/Users/wmoore/.virtualenv/plover/lib/python2.7/site-packages/pip/_vendor/requests/sessions.py", line 465, in request
    resp = self.send(prep, **send_kwargs)
  File "/Users/wmoore/.virtualenv/plover/lib/python2.7/site-packages/pip/_vendor/requests/sessions.py", line 573, in send
    r = adapter.send(request, **kwargs)
  File "/Users/wmoore/.virtualenv/plover/lib/python2.7/site-packages/pip/_vendor/cachecontrol/adapter.py", line 46, in send
    resp = super(CacheControlAdapter, self).send(request, **kw)
  File "/Users/wmoore/.virtualenv/plover/lib/python2.7/site-packages/pip/_vendor/requests/adapters.py", line 424, in send
    raise ConnectionError(e, request=request)
ConnectionError: HTTPSConnectionPool(host='pypi.python.org', port=443): Max retries exceeded with url: /packages/source/p/pyobjc-framework-Quartz/pyobjc-framework-Quartz-3.0.4.tar.gz (Caused by ReadTimeoutError("HTTPSConnectionPool(host='pypi.python.org', port=443): Read timed out. (read timeout=15)",))
 wmoore  ⓔ  plover  ~  Source  plover  pip install pyobjc-framework-Quartz wxversion                                                                                                           2   master
Collecting pyobjc-framework-Quartz
  Retrying (Retry(total=4, connect=None, read=None, redirect=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.python.org', port=443): Read timed out. (read timeout=15)",)': /packages/source/p/pyobjc-framework-Quartz/pyobjc-framework-Quartz-3.0.4.tar.gz
  Retrying (Retry(total=3, connect=None, read=None, redirect=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.python.org', port=443): Read timed out. (read timeout=15)",)': /packages/source/p/pyobjc-framework-Quartz/pyobjc-framework-Quartz-3.0.4.tar.gz
  Retrying (Retry(total=2, connect=None, read=None, redirect=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.python.org', port=443): Read timed out. (read timeout=15)",)': /packages/source/p/pyobjc-framework-Quartz/pyobjc-framework-Quartz-3.0.4.tar.gz
  Downloading pyobjc-framework-Quartz-3.0.4.tar.gz (3.2MB)
    100% |████████████████████████████████| 3.2MB 144kB/s
Collecting wxversion
  Could not find a version that satisfies the requirement wxversion (from versions: )
No matching distribution found for wxversion
 wmoore  ⓔ  plover  ~  Source  plover  pip install wxversion                                                                                                                                   1   master
Collecting wxversion
  Could not find a version that satisfies the requirement wxversion (from versions: )
No matching distribution found for wxversion

ln -s /usr/local/lib/python2.7/site-packages/wx.pth ~/.virtualenv/plover/lib/python2.7/site-packages

http://wiki.wxpython.org/wxPythonVirtualenvOnMac:

Another possible solution would be to modify the activate script created by virtualenv to also set the PYTHONHOME value in the environment, and then copy the framework's python binary into the virtualenv's bin dir, overwriting the python that is already there. That way you can still use "python" instead of whatever you named your wrapper script, but you would also have to ensure that you always use the activate script and never run the virtualenv's python without it.

ln -s /System/Library/Frameworks/Python.framework/Versions/2.7/bin/python2.7 bin/python

echo 'export PYTHONHOME=$VIRTUAL_ENV' >> bin/activate

cd ..
git clone --recursive https://github.com/qdot/cython-hidapi

# Needed to unhack virtualenv and make all of these succeed

pip install appdirs pyserial simplejson py2app Cython mock pyobjc-core pyobjc-framework-Cocoa pyobjc-framework-Quartz
Collecting appdirs
  Using cached appdirs-1.4.0-py2.py3-none-any.whl
Collecting pyserial
  Using cached pyserial-2.7.tar.gz
Collecting simplejson
  Using cached simplejson-3.8.0.tar.gz
Collecting py2app
  Using cached py2app-0.9.tar.gz
Collecting Cython
  Using cached Cython-0.23.4-cp27-none-macosx_10_6_intel.macosx_10_9_intel.macosx_10_9_x86_64.macosx_10_10_intel.macosx_10_10_x86_64.whl
Collecting mock
  Using cached mock-1.3.0-py2.py3-none-any.whl
Collecting pyobjc-core
  Using cached pyobjc-core-3.0.4.tar.gz
Collecting pyobjc-framework-Cocoa
  Using cached pyobjc-framework-Cocoa-3.0.4.tar.gz
Collecting pyobjc-framework-Quartz
  Using cached pyobjc-framework-Quartz-3.0.4.tar.gz
Collecting altgraph>=0.12 (from py2app)
  Downloading altgraph-0.12.tar.gz (492kB)
    100% |████████████████████████████████| 495kB 702kB/s
Collecting modulegraph>=0.12 (from py2app)
  Downloading modulegraph-0.12.1.tar.gz (677kB)
    100% |████████████████████████████████| 679kB 633kB/s
Collecting macholib>=1.5 (from py2app)
  Downloading macholib-1.7.tar.gz (475kB)
    100% |████████████████████████████████| 479kB 735kB/s
Collecting funcsigs (from mock)
  Downloading funcsigs-0.4-py2.py3-none-any.whl
Collecting pbr>=0.11 (from mock)
  Downloading pbr-1.8.1-py2.py3-none-any.whl (89kB)
    100% |████████████████████████████████| 90kB 2.0MB/s
Collecting six>=1.7 (from mock)
  Downloading six-1.10.0-py2.py3-none-any.whl
Building wheels for collected packages: pyserial, simplejson, py2app, pyobjc-core, pyobjc-framework-Cocoa, pyobjc-framework-Quartz, altgraph, modulegraph, macholib
  Running setup.py bdist_wheel for pyserial
  Stored in directory: /Users/wmoore/Library/Caches/pip/wheels/46/06/d0/0a8f8136db90567df3ed02d9d15391178e350576a7a7fb03fa
  Running setup.py bdist_wheel for simplejson
  Stored in directory: /Users/wmoore/Library/Caches/pip/wheels/d6/cd/cc/ebf794f523ba74d9737f4447fccfb9bc6321539839966b8a56
  Running setup.py bdist_wheel for py2app
  Stored in directory: /Users/wmoore/Library/Caches/pip/wheels/9b/8c/28/d407c3339df8ad72f50fb95fa567fa292172328bfd30bec6b2
  Running setup.py bdist_wheel for pyobjc-core
  Stored in directory: /Users/wmoore/Library/Caches/pip/wheels/0a/9d/28/589d43c296d4992c8b715d78b69d8b701e811cb9e5351e50d9
  Running setup.py bdist_wheel for pyobjc-framework-Cocoa
  Stored in directory: /Users/wmoore/Library/Caches/pip/wheels/13/ce/47/ca7de183d3731f9bac1e76ecd042e60af1bad229b6e7b156ce
  Running setup.py bdist_wheel for pyobjc-framework-Quartz
  Stored in directory: /Users/wmoore/Library/Caches/pip/wheels/8e/3b/ff/cf083cfc47da02558bac846fe184e047280c7bbf0c96be654b
  Running setup.py bdist_wheel for altgraph
  Stored in directory: /Users/wmoore/Library/Caches/pip/wheels/c3/88/5f/cbd6dd1ececfc298b4486db7156e1a60f918187cc391465be0
  Running setup.py bdist_wheel for modulegraph
  Stored in directory: /Users/wmoore/Library/Caches/pip/wheels/c9/4b/93/ef914077dab9e8c93f0639850d8b90e6566721acea0c104bc7
  Running setup.py bdist_wheel for macholib
  Stored in directory: /Users/wmoore/Library/Caches/pip/wheels/9f/83/9f/05c1631d88cfb66bfdcdf11fc90a857b07d5fc340b2e439b7c
Successfully built pyserial simplejson py2app pyobjc-core pyobjc-framework-Cocoa pyobjc-framework-Quartz altgraph modulegraph macholib
Installing collected packages: appdirs, pyserial, simplejson, altgraph, modulegraph, macholib, py2app, Cython, funcsigs, pbr, six, mock, pyobjc-core, pyobjc-framework-Cocoa, pyobjc-framework-Quartz
Successfully installed Cython-0.23.4 altgraph-0.12 appdirs-1.4.0 funcsigs-0.4 macholib-1.7 mock-1.3.0 modulegraph-0.12.1 pbr-1.8.1 py2app-0.9 pyobjc-core-3.0.4 pyobjc-framework-Cocoa-3.0.4 pyobjc-framework-Quartz-3.0.4 pyserial-2.7 simplejson-3.8.0 six-1.10.0

# Then rehack virtualenv and source activate again

python setup-mac.py install

sed -i .bak -e 's/\.scan_code/._scan_code/' -e 's/\.load_module/._load_module/' ~/.virtualenv/plover/lib/python2.7/site-packages/py2app/recipes/virtualenv.py

cd ../plover
make dist/Plover.app



