module ImageStitch

using FileIO, Images
#using OEMTIFF #zero array
using TiffImages
using ImageView
using NRRD

using RegisterQD, CoordinateTransformations
using OffsetArrays
using LinearAlgebra
using StatsBase
using JLD2
using Statistics #for median
using Unitful

export checkimgs, merged_axes, merge_images, getOffsetOrigin
# Write your package code here.
#import Unitful: s

## Check image
function checkimgs(img1, img2)
  imgsub0 = similar(img1)
    for i in 1:size(img1, 3)
      if i%2 != 0
        imgsub0[:,:,i] = img2[:,:,i]
      else
        imgsub0[:,:,i] = img1[:,:,i-1]
      end
    end
  return(imgsub0)
end

## Merge image and save data into the hard drive
function merged_axes(img1, imgw)
  axs = 
      min(minimum(axes(imgw, 1)), minimum(axes(img1, 1))):max(maximum(axes(imgw, 1)), maximum(axes(img1, 1))),
      min(minimum(axes(imgw, 2)), minimum(axes(img1, 2))):max(maximum(axes(imgw, 2)), maximum(axes(img1, 2))),
      min(minimum(axes(imgw, 3)), minimum(axes(img1, 3))):max(maximum(axes(imgw, 3)), maximum(axes(img1, 3)))
  axs
end

function merge_images(fn, img1, imgw)
  axs = merged_axes(img1, imgw)
  ss = open(fn, "w+")
  for i in axs[3]
    for j in axs[2]
      for k in axs[1]  
        if i in axes(imgw,3) && j in axes(imgw,2) && k in axes(imgw,1) && imgw[k,j,i] != 0
          write(ss, UInt16(imgw[k,j,i].*typemax(UInt16)))
        elseif i in axes(img1,3) && j in axes(img1,2) && k in axes(img1,1)
          write(ss, UInt16(img1[k,j,i].*typemax(UInt16)))
        else
          write(ss, zero(UInt16))
        end
      end
    end
  end
  close(ss)
end

## calculate the origin for image stitch
function getOffsetOrigin(img, overlap_coords)
  xOrigin = -(length(axes(img,1))-length(overlap_coords[1])-1)
  yOrigin = -(length(axes(img,2))-length(overlap_coords[2])-1)
  zOrigin = -(length(axes(img,3))-length(overlap_coords[3])-1)
  return(xOrigin, yOrigin, zOrigin)
end

end
