# (c) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

# Contains all the custom Exception classes
module ILO_SDK
  class InvalidClient < StandardError # Client configuration is invalid
  end

  class InvalidRequest < StandardError # Could not make request
  end

  class BadRequest < StandardError # 400
  end

  class Unauthorized < StandardError # 401
  end

  class NotFound < StandardError # 404
  end

  class RequestError < StandardError # Other bad response codes
  end
end
