# About

WIP
Project goal is to create networked audio client/servers. The server will capture various audio input streams and send it to any connected nodes. Client will recieve audio data (with timestamps) and play back the stream in time with other clients. 

Secondary Goal is to learn Elixir

# Project inspirations

- [Snapcast](https://github.com/badaix/snapcast)
- [WaveSync](https://github.com/blaa/WaveSync)
- Sonos

# WIP NOTES
## State / Model
%{
  nodes: [list of connected nodes],
  streams: [list of streams]
}

``` elixir 
%Node{
  ref: :atom,
  name: human name (string),
  connected_stream: ref_to_stream || nil
}
```

```elixir 
%Stream{
  type: :atom, 
  active: true/false (is actively getting input)
  node: ref_to_node_where_stream_is_running
  metadata: map of additional attributes defined by the stream type
}
```

Would also need a way for the user to configure different streams (ie spotify or other streams that need credentials)

```elixir 
%AvailableStream{
  type: :atom,
  credentials: Map of credentials needed for the stream

}

```

## Stream Types
 - File
 - Input
 - Spotify
 ... dreams ...
  - Radio
  - Air Play 
  - Bluetooth
  - Chromecast
  - ...more ?

## Actions
 - New Node
 This would happen when a new node joins the cluster
 Could be processed by any node, just need to update the global presence state and then update the ui

 - Node Drops
 This would happen when a node leaves the cluster
 Could be processed by any node, 
 Would need to update the global presence state and UI
 Would need to attempt to move any streams that were running on that node  (for example a spotify stream could be moved to another node, but a local input stream could not be and that stream would need to be set to inactive)

 - Node changes human name
 This action would orinate from the UI
 Could be processed by any node
 Would need to update global presence state and UI

 - Node changes connected stream
 This Could come from the UI or the devise itself (assuming device had a physical knob)
 __Needs to be processed on the node that is changeing streams__
 Would need to update global presence state and UI
 Would need to update the pg2 group the node is connected to

 - New Stream
 This could come from the UI, the the device or from an external service (e.g user selects spotify device (although this scenario may fall under stream changes active from false to true))
 Could be processed by any node although the specifc node the stream is created for would matter

 - Stream changes active from false to true
 Would come from the node where the stream is running 
 __Needs to be processed on the node where the stream is__
 Would need to start broadcasting packets of incoming data

 - Stream changes active from true to false
 Would come from the stream GenServer running on a specific node
__Needs to be processed on the node that action originated from__
Would need to stop brodcasting
Should maybe tell any connected nodes to change their connected stream

 - Stream metadata is updated
 May come from from the node the stream is running on
could be processed by any node
would need to update global presence and the ui
