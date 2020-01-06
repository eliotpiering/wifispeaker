defmodule Firmware.ParsePcm do
  @bits_per_sample 16
  @channels 2
  @frames_per_second 44100

  # makes this 44100 chunks in a second
  @frames_in_chunks 100

  # makes this an even 100 chunks per second
  # @frames_in_chunks 441

  # 10 = @frames_in_chunks / @frames_per_second * 1000
  # @native_time_chunk_length System.convert_time_unit(10, :millisecond, :native)

  # 10 = @frames_in_chunks / @frames_per_second * 1000
  # set native time to 441000
  @native_time_chunk_length 1000

  @chunk_size @bits_per_sample * @channels * @frames_in_chunks
  # Float.round(@chunk_size / 8)
  # @chunk_size_in_bytes  1764
  @chunk_size_in_bytes 400

  # TODO use monotonic_time
  def parse_file(start_time) do
    File.read!("../ui/xab") |> parse(start_time, [])
  end

  def parse_chunks(binary, start_time) when bit_size(binary) > @chunk_size do
    parse(binary, start_time, [])
  end

  def parse_chunks(binary, start_time) do
    {:error, :not_enough}
  end

  def parse(binary, start_time, data) when bit_size(binary) > @chunk_size do
    <<one_chunk::binary-size(@chunk_size_in_bytes), rest::binary>> = binary
    parse(rest, start_time + @native_time_chunk_length, data ++ [{start_time, one_chunk}])
  end

  def parse(binary, start_time, data) do
    {:ok, (data ++ [{start_time, binary}]), start_time}
  end
end
