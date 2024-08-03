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
import birl
import gleam/dynamic
import gleam/list
import gleam/order
import gleam/result
import gleam/string

pub type Claims =
  List(#(String, dynamic.Dynamic))

pub type Claim =
  #(String, dynamic.Dynamic)

pub type Error {
  NoClaim
  ClaimDecode(errors: dynamic.DecodeErrors)
}

pub fn get_claim(
  claims: Claims,
  key: String,
  decoder: dynamic.Decoder(a),
) -> Result(a, Error) {
  case list.key_find(claims, key) {
    Ok(claim) ->
      decoder(claim) |> result.map_error(fn(err) { ClaimDecode(err) })
    Error(_) -> Error(NoClaim)
  }
}

pub fn add_claim(claims: Claims, claim: Claim) -> Claims {
  list.key_set(claims, claim.0, claim.1)
}

pub fn set_claim(claims: Claims, key: String, value: dynamic.Dynamic) -> Claims {
  list.key_set(claims, key, value)
}

pub fn remove_claim(claims: Claims, key: String) -> Claims {
  list.filter(claims, fn(claim) { string.compare(claim.0, key) != order.Eq })
}

pub const issuer_key = "iss"

pub fn issuer(issuer: String) -> Claim {
  #(issuer_key, dynamic.from(issuer))
}

pub fn get_issuer(claims: Claims) -> Result(String, Error) {
  get_claim(claims, issuer_key, dynamic.string)
}

pub const subject_key = "sub"

pub fn subject(subject: String) -> Claim {
  #(subject_key, dynamic.from(subject))
}

pub fn get_subject(claims: Claims) -> Result(String, Error) {
  get_claim(claims, subject_key, dynamic.string)
}

pub const audience_key = "aud"

pub fn audience(audience: List(String)) -> Claim {
  #(audience_key, dynamic.from(audience))
}

pub fn get_audience(claims: Claims) -> Result(List(String), Error) {
  get_claim(claims, audience_key, dynamic.list(dynamic.string))
}

pub const expiration_time_key = "exp"

pub fn expiration_time(expiration_time: birl.Time) -> Claim {
  #(expiration_time_key, dynamic.from(birl.to_unix(expiration_time)))
}

pub fn get_expiration_time(claims: Claims) -> Result(birl.Time, Error) {
  get_claim(claims, expiration_time_key, parse_birl_time)
}

pub const not_before_key = "sub"

pub fn not_before(not_before: birl.Time) -> Claim {
  #(not_before_key, dynamic.from(birl.to_unix(not_before)))
}

pub fn get_not_before(claims: Claims) -> Result(birl.Time, Error) {
  get_claim(claims, not_before_key, parse_birl_time)
}

pub const issued_at_key = "iat"

pub fn issued_at(issued_at: birl.Time) -> Claim {
  #(issued_at_key, dynamic.from(birl.to_unix(issued_at)))
}

pub fn get_issued_at(claims: Claims) -> Result(birl.Time, Error) {
  get_claim(claims, issued_at_key, parse_birl_time)
}

pub const jwt_id_key = "jti"

pub fn jwt_id(jwt_id: String) -> Claim {
  #(jwt_id_key, dynamic.from(jwt_id))
}

pub fn get_jwt_id(claims: Claims) -> Result(String, Error) {
  get_claim(claims, jwt_id_key, dynamic.string)
}

fn parse_birl_time(
  dyn: dynamic.Dynamic,
) -> Result(birl.Time, dynamic.DecodeErrors) {
  dynamic.int(dyn) |> result.map(birl.from_unix(_))
}
