#!/bin/sh

#http POST https://jsonplaceholder.typicode.com/posts title=foo body=bar userId:=9 | jq '{"id"}'
#_VALUE=$(http POST https://jsonplaceholder.typicode.com/posts title=foo body=bar userId:=9 | jq '{"id"}' | grep "\:" | sed -e "s/^.*\: //")
_VALUE=$(http POST https://jsonplaceholder.typicode.com/posts title=foo body=bar userId:=9 | grep "\"id\":" | sed -e "s/^.*\: //" | sed -e "s/,$//")