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
import gjwt/claim
import gjwt/jsonify
import gleam/dynamic
import gleam/dynamic/decode
import gleam/json
import gleam/list

pub type Payload {
  Payload(claims: claim.Claims)
}

pub fn new() -> Payload {
  Payload([])
}

pub fn get_claim(
  payload: Payload,
  key: String,
  decoder: decode.Decoder(a),
) -> Result(a, claim.Error) {
  claim.get_claim(payload.claims, key, decoder)
}

pub fn add_claim(payload: Payload, claim: claim.Claim) -> Payload {
  Payload(claim.add_claim(payload.claims, claim))
}

pub fn set_claim(
  payload: Payload,
  key: String,
  value: dynamic.Dynamic,
) -> Payload {
  Payload(claim.set_claim(payload.claims, key, value))
}

pub fn remove_claim(payload: Payload, key: String) -> Payload {
  Payload(claim.remove_claim(payload.claims, key))
}

pub fn to_json(payload: Payload) -> json.Json {
  json.object(
    list.map(payload.claims, fn(claim) { #(claim.0, jsonify.jsonify(claim.1)) }),
  )
}
