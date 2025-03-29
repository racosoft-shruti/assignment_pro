## request
# curl --location 'localhost:3000/pagination/users?page=1&per_page=2' \

## response
# {
#     "data": [
#         {
#             "id": 1,
#             "email": "shr@sh.com",
#             "name": "shruti",
#             "created_at": "2025-03-29T12:51:30.107Z",
#             "updated_at": "2025-03-29T12:51:30.107Z"
#         },
#         {
#             "id": 2,
#             "email": "shr@#ss{i}.com",
#             "name": "shruti0",
#             "created_at": "2025-03-29T17:40:34.938Z",
#             "updated_at": "2025-03-29T17:40:34.938Z"
#         }
#     ],
#     "mata": {
#         "current_page_no": 1,
#         "total_page_no": 51,
#         "next_page_no": 2,
#         "total_count": 101,
#         "previous_page": null
#     }
# }

class Pagination::UsersController < ApplicationController
  def index
    page_details, users = pagy(User.all, items: params[:per_page], page: params[:page])
    render json: {
      data: users,
      meta: {
        current_page_no: page_details.page, # gives record of users in current page
        total_page_no: page_details.pages, # Total count of pages
        next_page_no: page_details.next, # for next page no (or nil if there’s no next)
        total_count: page_details.count, # for total count of users
        previous_page: page_details.prev # for previous page
      }
    }, status: :ok
  end
end
