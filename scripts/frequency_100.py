import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1 import make_axes_locatable

from pyram.PyRAM import PyRAM

import sys

def figure(pyram):
    fig, ax = plt.subplots()
    im = ax.imshow(pyram.tlg, cmap="jet_r", aspect="auto")
    ax.set_xlabel(f"Range ($m$)")
    ax.set_ylabel(f"Depth ($m$)")
    ax.ticklabel_format(axis="x", style="sci", scilimits=(3,3))
    ax.tick_params(axis="both", labelsize="7")
    ax.xaxis.set_major_formatter(plt.FuncFormatter(lambda value, _: value * pyram._dr))
    ax.yaxis.set_major_formatter(plt.FuncFormatter(lambda value, _: value * pyram._dz))
    divider = make_axes_locatable(ax)
    cax = divider.append_axes("bottom", size="8%", pad=0.8)
    clb = fig.colorbar(im, orientation="horizontal", cax=cax)
    cax.set_title(r"Transmission Loss ($dB$)", fontsize="10")
    cax.tick_params(axis="both", labelsize="7")
    return fig, ax

def model():
    # Frequency
    f = 100

    # Emitter and Reciever immersion
    zs, zr = 20, 20

    # Depths and z-step
    zmplt = 140
    dz = 1

    # Ranges and step
    rmax, dr = 2e3, 1

    # Water sound speed along z and r
    z_ss=np.array([0, zmplt])
    rp_ss=np.array([0, rmax])
    cw=np.array([[1500, 1500], [1500, 1500]])

    # Seabed sound speed along z and r
    z_sb=np.array([0])
    rp_sb=np.array([0])
    cb=np.array([[1700]])

    # Seabed density
    rhob=np.array([[1.5]])
    
    # Seabed attenuation factor
    attn=np.array([[1]])

    # Bathymetry [ranges, depths]
    rbzb=np.array([[0, 100], [2e3, 100]])

    # Celerity reference
    c0 = 1500

    pyram = PyRAM(f, zs, zr, z_ss, rp_ss, cw, z_sb, rp_sb, cb, rhob, attn, rbzb, rmax=rmax, dr=dr, dz=dz, zmplt=zmplt, c0=c0)
    pyram.run()
    return pyram

if __name__ == "__main__":
    args = sys.argv
    if len(args)>1:
        figname = args[1]
    else :
        figname = 'build/images/frequency_50.pdf'
    pyram = model()
    fig, ax = figure(pyram)
    plt.tight_layout()
    plt.savefig(figname, format="pdf")