from mpi4py import MPI
import numpy as np
import socket

comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = comm.Get_size()
hostname = socket.gethostname()

# -- 1. Broadcast: root sends a number to all
if rank == 0:
    data = 42
    print(f"[{rank}] Broadcasting value {data}")
else:
    data = None
data = comm.bcast(data, root=0)
assert data == 42, f"Rank {rank}: Broadcast failed"

# -- 2. Reduce: each rank contributes its rank, sum at root
local_value = rank
sum_result = comm.reduce(local_value, op=MPI.SUM, root=0)
if rank == 0:
    expected = sum(range(size))
    print(f"[{rank}] Reduce result = {sum_result} (expected {expected})")
    assert sum_result == expected, "Reduce failed"

# -- 3. Gather: each rank sends its value to root
gathered = comm.gather(rank * 2, root=0)
if rank == 0:
    print(f"[{rank}] Gathered data: {gathered}")
    expected = [i * 2 for i in range(size)]
    assert gathered == expected, "Gather failed"

# -- 4. Point-to-point test using Sendrecv (safe from deadlock)
if size > 1:
    send_array = np.array([rank] * 5, dtype=np.float64)
    recv_array = np.empty_like(send_array)

    # cyclic send: each rank sends to (rank + 1) % size
    src = (rank - 1 + size) % size
    dest = (rank + 1) % size

    print(f"[{rank}] Sending to {dest}, receiving from {src}", flush=True)

    comm.Sendrecv(sendbuf=send_array, dest=dest, sendtag=200,
                  recvbuf=recv_array, source=src, recvtag=200)

    print(f"[{rank}] Received array: {recv_array}", flush=True)

    expected = np.array([src] * 5, dtype=np.float64)
    assert np.allclose(recv_array, expected), f"Rank {rank}: Sendrecv failed"
else:
    print(f"[{rank}] Only one rank — skipping Sendrecv test.", flush=True)

# -- Final message
print(f"[{rank}] All tests passed on {hostname}")

