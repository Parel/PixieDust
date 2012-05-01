###*
Creates an oscillator function with the given parameters.

@name Oscillator
@constructor
@params {Number} amplitude How much to scale the osci 
###
Oscillator = (options={}) ->
  {amplitude, period, offset} = options

  amplitude = 1 unless amplitude?
  period = 1 unless period?
  offset = 0 unless offset?

  return (t) ->
    amplitude * Math.cos(Math.TAU * t / period + offset)
