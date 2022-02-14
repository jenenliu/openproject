#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2021 the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See COPYRIGHT and LICENSE files for more details.
#++

require 'spec_helper'

describe ::API::V3::FileLinks::FileLinkRepresenter, 'parsing' do
  let(:file_link) { build_stubbed(:file_link) }

  current_user { build_stubbed(:user) }

  describe 'parsing' do
    subject(:parsed) { representer.from_hash parsed_hash }

    let(:representer) do
      described_class.create(file_link, current_user: current_user)
    end

    let(:parsed_hash) do
      {
        "_type" => "FileLink",
        "originData" => {
          "id" => 5503,
          "name" => "logo.png",
          "mimeType" => "image/png",
          "createdAt" => "2021-12-19T09:42:10.170Z",
          "lastModifiedAt" => "2021-12-20T14:00:13.987Z",
          "createdByName" => "Luke Skywalker",
          "lastModifiedByName" => "Anakin Skywalker"
        }
      }
    end

    describe 'given createdAt and updatedAt' do
      let(:parsed_hash) do
        {
          "createdAt" => "2022-02-09T10:03:37Z",
          "updatedAt" => "2022-02-09T10:03:37Z"
        }
      end

      it 'are not used by the parsing' do
        expect(parsed).not_to have_attributes(
          created_at: DateTime.parse(parsed_hash["createdAt"]).in_time_zone,
          updated_at: DateTime.parse(parsed_hash["updatedAt"]).in_time_zone
        )
      end
    end

    describe 'originData' do
      it 'is parsed correctly' do
        expect(parsed).to have_attributes(
          origin_id: "5503",
          origin_name: "logo.png",
          origin_mime_type: "image/png",
          origin_created_by_name: "Luke Skywalker",
          origin_last_modified_by_name: "Anakin Skywalker",
          origin_created_at: DateTime.new(2021, 12, 19, 9, 42, 10.17, '+00:00').in_time_zone,
          origin_updated_at: DateTime.new(2021, 12, 20, 14, 0, 13.987, '+00:00').in_time_zone
        )
      end
    end
  end
end
