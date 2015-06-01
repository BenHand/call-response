require_relative '../db/setup'
require_relative '../lib/all'
# Remember to put the requires here for all the classes you write and want to use

def parse_params(uri_fragments, query_param_string)
  params = {}
  params[:resource]  = uri_fragments[3]
  params[:id]        = uri_fragments[4]
  params[:action]    = uri_fragments[5]
  if query_param_string
    param_pairs = query_param_string.split('&')
    param_k_v   = param_pairs.map { |param_pair| param_pair.split('=') }
    param_k_v.each do |k, v|
      params.store(k.to_sym, v)
    end
  end
  @test_params = params
  params
end

def display_values(passed_value)
    puts "200 OK"
    names = passed_value
    names.each do |value|
        puts "#{value.id}) #{value.last_name}, #{value.first_name} : #{value.age} years old"
        end
end

def parse(raw_request)
  pieces = raw_request.split(' ')
  method = pieces[0]
  uri    = pieces[1]
  http_v = pieces[2]
  route, query_param_string = uri.split('?')
  uri_fragments = route.split('/')
  protocol = uri_fragments[0][0..-2]
  full_url = uri_fragments[2]
  subdomain, domain_name, tld = full_url.split('.')
  params = parse_params(uri_fragments, query_param_string)
  return {
    method: method,
    uri: uri,
    http_version: http_v,
    protocol: protocol,
    subdomain: subdomain,
    domain_name: domain_name,
    tld: tld,
    full_url: full_url,
    params: params
  }
end

system('clear')
loop do
  print "Supply a valid HTTP Request URL (h for help, q to quit) > "
  raw_request = gets.chomp

  case raw_request
  when 'q' then puts "Goodbye!"; exit
  when 'h'
    puts "A valid HTTP Request looks like:"
    puts "\t'GET http://localhost:3000/students HTTP/1.1'"
    puts "Read more at : http://www.w3.org/Protocols/rfc2616/rfc2616-sec5.html"
  else
    REQUEST = parse(raw_request)
    PARAMS  = REQUEST[:params]

    if REQUEST[:method] == 'GET'

      if PARAMS[:resource] == 'users' && PARAMS[:id] == nil && @test_params.length < 4 && PARAMS[:action] == nil
          display_values(User.all)

      elsif PARAMS[:resource] == 'users' && PARAMS[:id] != nil

        if User.find_by_id(PARAMS[:id])
          display_values(User.find(PARAMS[:id]))

        else puts "Error 404: Not Found"
        end

      elsif PARAMS.include?(:first_name)
          display_values(User.where("first_name LIKE (?)", "#{PARAMS[:first_name]}%"))
      elsif PARAMS.include?(:limit)

        if PARAMS.include?(:offset)
          display_values(User.all.limit(PARAMS[:limit]).offset(PARAMS[:offset]))
        else
          display_values(User.all.limit(PARAMS[:limit]))
        end

      end

    elsif REQUEST[:method] == "DELETE"
      name = User.find(PARAMS[:id])
      puts "Deleting - #{name.id}) #{name.last_name}, #{name.first_name} from the database."
      User.destroy(PARAMS[:id])

    # elsif REQUEST[:method] == "POST"
    #   puts REQUEST
    #   puts PARAMS
      # name = User.create(first_name: (PARAMS[:first_name].to_s), last_name: (PARAMS[:last_name].to_s), age: (PARAMS[:age].to_i))
      # display_values(name)

      # POST http://localhost:3000/users 'first_name:"Justin",last_name:"Herrick",age:"99"' HTTP/1.1
    end

  end

end
