{ lib
, aiohttp
, aresponses
, async-timeout
, attrs
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "py17track";
  version = "3.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "1rnq9ybzj2l3699mjyplc29mxla8fayh52x52cnsz21ixlfd9fky";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    attrs
    pytz
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'attrs = ">=19.3,<21.0"' 'attrs = ">=19.3,<22.0"' \
      --replace 'async-timeout = "^3.0.1"' 'async-timeout = ">=3.0.1,<5.0.0"'
  '';

  disabledTestPaths = [
    # Ignore the examples directory as the files are prefixed with test_
    "examples/"
  ];

  pythonImportsCheck = [
    "py17track"
  ];

  meta = with lib; {
    description = "Python library to track package info from 17track.com";
    homepage = "https://github.com/bachya/py17track";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
