# type: ignore
import matplotlib.pyplot as plt

def run():
    print("Plotting from Python...")
    x = [0, 1, 2, 3, 4]
    y = [i**2 for i in x]
    plt.plot(x, y)
    plt.title("Basic Plot from Python")
    plt.xlabel("X-axis")
    plt.ylabel("Y-axis")
    plt.grid(True)
    plt.show()

if __name__ == "__main__":
    run()