# FaceSnaps API
This API is a mock of the Instagram API. It serves as the backend for the FaceSnaps iOS Application.

# Endpoints

## User Endpoints

POST /users/sign_up -> Sign up a new user (requires password, email, fullname, and username)

POST /users/sign_up/check_availability -> Submit either a username or email to see if it is available (submit as user_credential)

GET/users/self -> Get information about the owner of the access token

GET /users/**user-id** -> get information about a user

GET /users/self/media/recent -> get most recent media of the user (*paginated)

GET /users/**user-id**/media/recent -> get most recent media of a user (*paginated)

GET /users/self/media/liked -> get the most recent media liked by the user (*paginated)

POST /users/search -> search for a user by name (*paginated)

## Relationships

GET /users/self/follows -> get list of users this user follows

GET /users/self/followed-by -> get the list of users this user is followed by

GET /users/self/requested-by -> list of users who have requested to follow the user

GET /users/**user-id**/relationship -> get information about a relationship to another user.

POST /users/**user-id**/relationship -> modify the relationship with target user

- specify action within the params:
    - action: follow | unfollow | approve | ignore
 
 
## Posts

GET /posts/**post-id** -> get information about a post object

GET /posts/search -> search for recent posts in a given area (*paginated)

## Likes

GET /posts/**post-id**/likes -> get a list of users who have liked this post

POST /posts/**post-id**/likes -> set a like on this post by the current user

DEL /posts/**post-id**/likes -> remove a like on this post by the current user

## Comments

GET /posts/**post-id**/comments -> get a list of comments on a post object. (*paginated in reverse)

POST /posts/**post-id**/comments -> create a comment on a post object.

DEL /posts/**post-id**/comments/**comment-id** -> remove a comment.

## Tags

GET /tags/tag-name

GET /tags/tag-name/media/recent

GET /tags/search

## Locations

GET /locations/location-id -> get information about a location

GET /locations/location-id/posts/recent -> get list of post objects from a given location

GET /locations/search -> search for a location by geographic coordinate

- specify in params:
    - lat, lng, and query (name)
 
 
## Pagination

- Uses kaminari and api_paginate to generate pagination
- Pagination for the api is handled through the params (no page = page 1), and the HTTP Header Response (Total items, Per-Page, and links for last/next/prev)