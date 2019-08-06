SoTh = function(x, lambda)
{
  if (lambda==0) return (x)
  if (x > lambda) return (x-lambda)
  if (x < -lambda) return (x+lambda)
  return (0)
}