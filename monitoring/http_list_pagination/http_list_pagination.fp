pipeline "http_list_pagination" {
  title       = "HTTP List Pagination"
  description = "Paginate the response from HTTP list call."

  step "http" "http_list_pagination" {
    method = "get"
    url    = "https://pokeapi.co/api/v2/berry?limit=25"

    loop {
      until = result.response_body.next == null
      url   = result.response_body.next
    }
  }

  output "berries" {
    description = "The list of berries consumed by Pokemon."
    value       = flatten([for page, berries in step.http.http_list_pagination : berries.response_body.results])
  }

}
