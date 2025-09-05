# Setting up OPeNDAP

NASAPrecipitation.jl downloads data from NASA's EOSDIS OPeNDAP servers, which requires registering an account to acces the data. The steps are as follows:

1. You need to register an account with Earthdata and allow access to the NASA EOSDISC on it.
2. Create a `.netrc` file with the following information: `machine urs.earthdata.nasa.gov login <your login> password <your password>`
3. Create a `.dodsrc` file with the following lines: (1) `HTTP.COOKIEJAR=/<home directory>/.urs_cookies` and (2) `HTTP.NETRC=/<home directory>/.netrc`

If this sounds complicated however, fear not! You need only perform the first step yourself (i.e. create your own account). NASAPrecipitation.jl will automatically set up the `.dodsrc` file (if you don't already have one), and once you have your `<login>` and `<password>`, you can use the function `setup()` to set up your `.netrc` file.

```
using NASAPrecipitation

setup(
    login = <username>
    password = <password>
)
```