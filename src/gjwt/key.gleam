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

/// For kty see https://hexdocs.pm/jose/readme.html
pub type Key {
  Key(key: BitArray, algorithm: String, kty: String)
}

pub const default_kty = "oct"

pub fn from_string(key: String, algorithm: String) -> Key {
  Key(bit_array.from_string(key), algorithm, default_kty)
}
