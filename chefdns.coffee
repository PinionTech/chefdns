fs = require 'fs'
dns = require 'native-dns'
chef = require 'chef'
conf = require './conf'

conf.ttl or= 300
conf.port or= 53
conf.authFile or= './auth.pem'

server = dns.createServer()
chefClient = chef.createClient 'chefdns-apiclient',
  fs.readFileSync(conf.authFile),
  conf.chefServer


cache = {}

server.on 'request', (request, response) ->
  return response.send() if conf.filter and !request.question[0].name.match conf.filter
  # Only use the subbest domain
  name = request.question[0].name.split('.')[0]

  if address = cache[name]
    response.answer.push dns.A
      name: request.question[0].name,
      address: address,
      ttl: conf.ttl,
    console.log "returning", address, "from cache"
    return response.send()

  chefClient.get "/nodes/#{name}", (err, node) ->
    if err or node.error
      console.log "requested unknown name, #{name}", err?.message or node.error
    else if address = (node.automatic.cloud?.public_ipv4 or node.automatic.ipaddress)
      cache[name] = address
      setTimeout ->
        delete cache[name]
      , conf.ttl*1000
      
      console.log "returning", address, "from chef lookup"
      response.answer.push dns.A
        name: request.question[0].name,
        address: address,
        ttl: conf.ttl,
    response.send()

server.on 'error', (err, buff, req, res) ->
  console.log(err.stack)

server.serve conf.port or 53
