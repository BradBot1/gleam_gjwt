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
import gleam/bit_array
import gleam/dict
import gleam/dynamic
import gleam/dynamic/decode
import gleam/json

pub fn jsonify(dyn: dynamic.Dynamic) -> json.Json {
  let decoder =
    decode.one_of(decode.string |> decode.map(json.string), or: [
      decode.int |> decode.map(json.int),
      decode.float |> decode.map(json.float),
      decode.bool |> decode.map(json.bool),
      decode.bit_array
        |> decode.map(fn(v) { bit_array.base64_encode(v, True) |> json.string }),
      decode.dict(decode.string, decode.dynamic |> decode.map(jsonify))
        |> decode.map(fn(v) { dict.to_list(v) |> json.object }),
      decode.list(decode.dynamic |> decode.map(jsonify))
        |> decode.map(json.preprocessed_array),
      decode.failure(
        json.null(),
        "Unknown type "
          <> dynamic.classify(dyn)
          <> " was provided! Make sure to convert this type to JSON before adding to JWT payload!",
      ),
    ])
  let assert Ok(json) = decode.run(dyn, decoder)
  json
}
