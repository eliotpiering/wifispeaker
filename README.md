# Commands
Firmware.Receiver.subscribe(:"n1@127.0.0.1")
Firmware.ParsePcm.parse(System.os_time(441_000) + 5*441_000) |> Enum.each(&(Firmware.Server.broadcast(&1)))


# State / Model
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

# Stream Types
 - File
 - Input
 - Spotify
 ... dreams ...
  - Radio
  - Air Play 
  - Bluetooth
  - Chromecast
  - ...more ?

# Actions
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







# Hello Phoenix

This example demonstrates a basic poncho project for deploying a [Phoenix
Framework]-based application to a Nerves device. A "poncho project" is similar
to an umbrella project except that it's actually multiple separate-but-related
Elixir apps that use `path` dependencies instead of `in_umbrella` dependencies.
You can read more about the motivations behind this concept on the
embedded-elixir blog post about [Poncho Projects].

## Hardware

This example serves a Phoenix-based web page over the network. The steps below
assume you are using a Raspberry Pi Zero, which allows you to connect a single
USB cable to the port marked "USB" to get both network and serial console
access to the device. By default, this example will use the virtual Ethernet
interface provided by the USB cable, assign an IP address automatically, and
make it discoverable using mDNS (Bonjour). For more information about how to
configure the network settings for your environment, including WiFi settings,
see the `hello_network` example.

## How to Use this Repository

1. Connect your target hardware to your host computer or network as described
   above
2. Prepare your Phoenix project to build JavaScript and CSS assets:

    ```bash
    # These steps only need to be done once.
    cd ui
    mix deps.get
    cd assets
    npm install
    ```

3. Build your assets and prepare them for deployment to the firmware:

    ```bash
    # Still in ui/assets directory from the prior step.
    # These steps need to be repeated when you change JS or CSS files.
    node node_modules/webpack/bin/webpack.js --mode production
    cd ../
    mix phx.digest
    ```

4. Change to the `firmware` app directory

    ```bash
    cd ../firmware
    ```

5. Specify your target and other environment variables as needed:

    ```bash
    export MIX_TARGET=rpi0
    # If you're using WiFi:
    # export NERVES_NETWORK_SSID=your_wifi_name
    # export NERVES_NETWORK_PSK=your_wifi_password
    ```

6. Get dependencies, build firmware, and burn it to an SD card:

    ```bash
    mix deps.get
    mix firmware
    mix firmware.burn
    ```

7. Insert the SD card into your target board and connect the USB cable or otherwise power it on
8. Wait for it to finish booting (5-10 seconds)
9. Open a browser window on your host computer to `http://nerves.local/`
10. You should see a "Welcome to Phoenix!" page

[Phoenix Framework]: http://www.phoenixframework.org/
[Poncho Projects]: http://embedded-elixir.com/post/2017-05-19-poncho-projects/

## Learn More

* Official docs: https://hexdocs.pm/nerves/getting-started.html
* Official website: https://nerves-project.org/
* Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
* Source: https://github.com/nerves-project/nerves
