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
import gleam/dict
import gleam/dynamic
import gleam/json

pub fn jsonify(dyn: dynamic.Dynamic) -> json.Json {
  case dynamic.classify(dyn) {
    "String" -> dynamic.unsafe_coerce(dyn) |> json.string
    "Float" -> dynamic.unsafe_coerce(dyn) |> json.float
    "Int" -> dynamic.unsafe_coerce(dyn) |> json.int
    "Bool" -> dynamic.unsafe_coerce(dyn) |> json.bool
    "BitArray" -> dynamic.unsafe_coerce(dyn)
    "Map" | "Dict" ->
      dynamic.unsafe_coerce(dyn)
      |> dynamic.dict(dynamic.string, dynamic.dynamic)
      |> force_result
      |> dict.map_values(fn(_, value) { jsonify(value) })
      |> dict.to_list
      |> json.object
    "List" -> dynamic.unsafe_coerce(dyn) |> json.array(jsonify)
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
