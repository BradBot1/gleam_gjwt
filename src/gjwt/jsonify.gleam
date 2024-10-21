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
import gleam/json
import gleam/list

pub fn jsonify(dyn: dynamic.Dynamic) -> json.Json {
  case dynamic.classify(dyn) {
    "String" -> dyn |> dynamic.string |> force_result |> json.string
    "Float" -> dyn |> dynamic.float |> force_result |> json.float
    "Int" -> dyn |> dynamic.int |> force_result |> json.int
    "Bool" -> dyn |> dynamic.bool |> force_result |> json.bool
    "BitArray" ->
      dyn
      |> dynamic.bit_array
      |> force_result
      |> bit_array.base64_url_encode(True)
      |> json.string
    "Map" | "Dict" ->
      dyn
      |> dynamic.dict(dynamic.string, dynamic.dynamic)
      |> force_result
      |> dict.map_values(fn(_, value) { jsonify(value) })
      |> dict.to_list
      |> json.object
    "List" ->
      dyn
      |> dynamic.list(dynamic.dynamic)
      |> force_result
      |> list.map(jsonify)
      |> json.preprocessed_array()
    unkown ->
      panic as {
        "Unkown type "
        <> unkown
        <> " was provided! Make sure to convert this type to JSON before adding to JWT payload!"
      }
  }
}

fn force_result(res: Result(a, dynamic.DecodeErrors)) -> a {
  let assert Ok(value) = res
  value
}
