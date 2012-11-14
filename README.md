# RImageAnalysisTools

This package wraps the [ImageAnalysisTools library](http://cjfuller.github.com/imageanalysistools/) and provides additional ruby methods for easier scripting.

## Requirements

Requires [JRuby](http://jruby.org) (since the library it depends on is written in java).  Not tested on versions prior to 1.7.

## Installation

`gem build rimageanalysistools.gemspec`

`gem install rimageanalysistools-[version]-java.gem`

This will fetch the latest build of the ImageAnalysisTools library and any required dependencies automatically.

## Usage

`require 'rimageanalysistools'`

This will load the ImageAnalysisTools library and a few basic convenience methods included within that library.  More functionality can be added separately by requiring individual files, e.g.:

`require 'rimageanalysistools/get_image'`

## License

RImageAnalysisTools is licensed under the MIT/X11 license (see LICENSE file for exact text).  Dependencies of the ImageAnalysisTools library may use separate licenses.  See the [license information](https://github.com/cjfuller/imageanalysistools/tree/master/LICENSES) in the ImageAnalysisTools repository for more information.


