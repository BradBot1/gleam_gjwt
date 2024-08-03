%   Copyright 2024 BradBot_1

%   Licensed under the Apache License, Version 2.0 (the "License");
%   you may not use this file except in compliance with the License.
%   You may obtain a copy of the License at

%       http://www.apache.org/licenses/LICENSE-2.0

%   Unless required by applicable law or agreed to in writing, software
%   distributed under the License is distributed on an "AS IS" BASIS,
%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%   See the License for the specific language governing permissions and
%   limitations under the License.
-module(gjwt_ffi).

-export([to_jwt/4]).
-export([verify/3]).
-export([from_jwt/3]).

to_jwt(Protected, Kty, Payload, Key) ->
    element(2, jose_jws:compact(jose_jwt:sign(#{
        <<"kty">> => Kty,
        <<"k">> => jose_base64url:encode(Key)
    }, Protected, Payload))).

verify(Jwt, Kty, Key) ->
    element(1, from_jwt(Jwt, Kty, Key)).

from_jwt(Jwt, Kty, Key) ->
    jose_jwt:verify(#{
        <<"kty">> => Kty,
        <<"k">> => jose_base64url:encode(Key)
    }, Jwt).