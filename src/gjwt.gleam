//  Copyright 2024 BradBot_1

//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at

//      http://www.apache.org/licenses/LICENSE-2.0

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
import gjwt/header
import gjwt/key
import gjwt/payload
import gleam/bit_array
import gleam/dict
import gleam/dynamic
import gleam/erlang/atom
import gleam/list

pub type JWT =
  #(header.Header, payload.Payload)

pub fn new() -> JWT {
  #(header.new(), payload.new())
}

pub fn add_header(jwt: JWT, key: String, value: dynamic.Dynamic) -> JWT {
  #(jwt.0 |> header.add_entry(#(key, value)), jwt.1)
}

pub fn add_claim(jwt: JWT, claim: #(String, dynamic.Dynamic)) -> JWT {
  #(jwt.0, jwt.1 |> payload.add_claim(claim))
}

pub fn sign_off(jwt: JWT, key: key.Key) -> String {
  case
    bit_array.to_string(do_to_jwt(
      [#("alg", dynamic.from(key.algorithm)), ..{ jwt.0 }.entries]
        |> dict.from_list,
      <<key.kty:utf8>>,
      { jwt.1 }.claims |> dict.from_list,
      key.key,
    ))
  {
    Ok(jwt) -> jwt
    Error(_) -> panic as "Failed to parse JWT into String!"
  }
}

pub fn verify(jwt_as_string: String, key: key.Key) -> Bool {
  do_verify(jwt_as_string, <<key.kty:utf8>>, key.key)
}

pub fn from_jwt(jwt_as_string: String, key: key.Key) -> Result(JWT, Nil) {
  let res = do_from_jwt(jwt_as_string, <<key.kty:utf8>>, key.key)
  case res.0 {
    True ->
      Ok(#(
        header.Header(
          { res.2 }.3
          |> dict.to_list
          |> list.key_set(
            "alg",
            dynamic.from(atom.to_string({ { res.2 }.1 }.1)),
          ),
        ),
        payload.Payload({ res.1 }.1 |> dict.to_list),
      ))
    False -> Error(Nil)
  }
}

@external(erlang, "gjwt_ffi", "to_jwt")
fn do_to_jwt(
  protected: dict.Dict(String, dynamic.Dynamic),
  kty: BitArray,
  payload: dict.Dict(String, dynamic.Dynamic),
  key: BitArray,
) -> BitArray

@external(erlang, "gjwt_ffi", "verify")
fn do_verify(token: String, kty: BitArray, key: BitArray) -> Bool

@external(erlang, "gjwt_ffi", "from_jwt")
fn do_from_jwt(
  token: String,
  kty: BitArray,
  key: BitArray,
) -> #(
  Bool,
  #(Nil, dict.Dict(String, dynamic.Dynamic)),
  #(Nil, #(Nil, atom.Atom), Nil, dict.Dict(String, dynamic.Dynamic)),
)
