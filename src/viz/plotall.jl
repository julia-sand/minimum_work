using Plots,CSV

# Generate some data
x = 1:10
y1 = rand(10)
y2 = rand(10)

# Create subplots
plot(
    plot(x, y1, title = "Panel 1", label = "y1", legend = :top),
    plot(x, y2, title = "Panel 2", label = "y2", legend = :top),
    layout = (1, 2),  # 1 row, 2 columns
    size = (800, 400)
)
