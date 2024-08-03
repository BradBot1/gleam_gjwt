# GJWT

[![Package Version](https://img.shields.io/hexpm/v/gjwt)](https://hex.pm/packages/gjwt)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gjwt/)

```sh
gleam add gjwt
```
```gleam
import birl
import birl/duration
import gjwt.{add_claim, add_header, new, sign_off, verify, from_jwt}
import gjwt/claim.{expiration_time}
import gjwt/key.{from_string}
import gleam/dynamic
import gleam/io

pub fn main() {
  let key = from_string(
    // your key
    "1111111111111111111111111111111111111111111111111111111111111113",
    // method to use
    "HS512",
  )
  let token = new()
  |> add_header("funky", dynamic.from(True))
  |> add_claim(#("test", dynamic.from("This is a test!")))
  |> add_claim(expiration_time(birl.add(birl.now(), duration.seconds(15))))
    // convert to JWT
  |> sign_off(key)
  io.debug(token) // Have a look at it
  case verify(token, key) {
    True -> io.debug("Valid verified token!")
    False -> io.debug("Bad token") // you shouldn't get here in this example
  }
  // attempt to parse the token
  case from_jwt(token, key) {
    Ok(verified_jwt) -> io.debug(verified_jwt)
    Error(_) -> io.debug("Bad token") // you shouldn't get here in this example
  }
}
```

Further documentation can be found at <https://hexdocs.pm/gjwt>.
