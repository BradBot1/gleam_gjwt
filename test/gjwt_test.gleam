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
import gjwt.{add_claim, add_header, from_jwt, new, sign_off, verify}
import gjwt/key.{from_string}
import gjwt/payload
import gleam/dynamic
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

fn generate_key() {
  from_string(
    "1111111111111111111111111111111111111111111111111111111111111113",
    "HS512",
  )
}

pub fn generate_jwt_test() {
  new()
  |> add_header("funky", dynamic.from(True))
  |> add_claim(#("test", dynamic.from("This is a test!")))
  |> sign_off(generate_key())
  |> should.equal(
    "eyJhbGciOiJIUzUxMiIsImZ1bmt5Ijp0cnVlLCJ0eXAiOiJKV1QifQ.eyJ0ZXN0IjoiVGhpcyBpcyBhIHRlc3QhIn0.C_Ul-uqCx9WhVKLHbMKJN5rFq7yhKx5GS5P10PM563--6Et3wtrNBVtFNL0saUGnICCgprWegdrHj2J-6iQ42w",
  )
}

pub fn verify_jwt_test() {
  let jwt =
    "eyJhbGciOiJIUzUxMiIsImZ1bmt5Ijp0cnVlLCJ0eXAiOiJKV1QifQ.eyJ0ZXN0IjoiVGhpcyBpcyBhIHRlc3QhIn0.C_Ul-uqCx9WhVKLHbMKJN5rFq7yhKx5GS5P10PM563--6Et3wtrNBVtFNL0saUGnICCgprWegdrHj2J-6iQ42w"
  verify(jwt, generate_key())
  |> should.be_true
}

pub fn from_jwt_test() {
  let jwt =
    "eyJhbGciOiJIUzUxMiIsImZ1bmt5Ijp0cnVlLCJ0eXAiOiJKV1QifQ.eyJ0ZXN0IjoiVGhpcyBpcyBhIHRlc3QhIn0.C_Ul-uqCx9WhVKLHbMKJN5rFq7yhKx5GS5P10PM563--6Et3wtrNBVtFNL0saUGnICCgprWegdrHj2J-6iQ42w"
  case from_jwt(jwt, generate_key()) {
    Ok(verified_jwt) ->
      verified_jwt.1
      |> payload.get_claim("test", dynamic.string)
      |> should.equal(Ok("This is a test!"))
    Error(_) -> should.fail()
  }
}
