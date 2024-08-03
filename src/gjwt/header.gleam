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
import gjwt/jsonify
import gleam/dynamic
import gleam/json
import gleam/list
import gleam/order
import gleam/result
import gleam/string

pub type HeaderEntry =
  #(String, dynamic.Dynamic)

pub type HeaderEntries =
  List(HeaderEntry)

pub type Header {
  Header(entries: HeaderEntries)
}

pub fn new() {
  Header([])
}

pub fn get_entries(header: Header) -> HeaderEntries {
  header.entries
}

pub fn get_entry(header: Header, key: String) -> Result(HeaderEntry, Nil) {
  header.entries
  |> list.key_find(key)
  |> result.map(fn(value) { #(key, value) })
}

pub fn add_entry(header: Header, entry: HeaderEntry) -> Header {
  Header(list.key_set(header.entries, entry.0, entry.1))
}

pub fn remove_entry(header: Header, key: String) -> Header {
  Header(
    list.filter(header.entries, fn(entry) {
      string.compare(entry.0, key) != order.Eq
    }),
  )
}

pub fn to_json(header: Header) -> json.Json {
  header.entries
  |> list.map(fn(data) { #(data.0, jsonify.jsonify(data.1)) })
  |> list.key_set("alg", json.string("none"))
  |> list.key_set("typ", json.string("JWT"))
  |> json.object
}
