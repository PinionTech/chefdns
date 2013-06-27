ChefDNS
=======

Have you ever gone hunting through `knife node list` in the search for a particular server's IP? In the habit of keeping a spare AWS tab open so you can copy and paste out public dns names? Written some terrifying shell script to keep your /etc/hosts in sync? Sync no more, my friend, the future has arrived.

On one of my pilgrimages through the darkest jungles of internet history, I found a remarkable and nearly-forgotten system for matching names of things to their ip addresses. The locals call it "DNS". And with nothing but a bit of node magic, you, too, can reap its benefits.

How to make it go
-----------------

First, have [NodeJS](http://nodejs.org/) installed. Then:

    $ git clone https://github.com/PinionTech/chefdns.git
    $ cd chefdns
    $ npm install
    $ knife client create -d chefdns-apiclient -f 'auth.pem'
    $ cp conf.example.coffee conf.coffee
    $ vim conf.coffee
    $ sudo node_modules/.bin/coffee chefdns.coffee # We need sudo to run on port 53

And in another terminal:

    $ dig @127.0.0.1 mychefnode
    $ dig @127.0.0.1 mychefnode.any.address.com # should work too

It's probably not very useful to just run queries locally, though. ChefDNS works best when you run it on an actual server somewhere and [delegate an NS record to it](http://serverfault.com/questions/27134/how-exactly-should-i-set-up-dns-to-delegate-authority-for-subdomains) with a short subdomain.

Should I point production traffic at a box running ChefDNS and put my faith in the blinding speed and scalability of DNS-via-HTTP-via-Rails-via-Erlang-via-Postgres?
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

Sure! I can't imagine how that could go wrong!
