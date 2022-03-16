# Check lsof
# Remember to Use Python 3.7 (conda create -n MEE python=3.7)

# install pytorch for CUDA 11.1 (we need to match pytorch version with CUDA version)
pip install torch==1.9.0+cu111 torchvision==0.10.0+cu111 torchaudio==0.9.0 -f https://download.pytorch.org/whl/torch_stable.html
if [ $? -ne 0 ]; then
    echo "[ERROR] Installing Pytorch Failed!"
    exit
fi

# horovod
HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_NCCL_LINK=SHARED HOROVOD_WITH_PYTORCH=1 \
    pip install --no-cache-dir horovod[pytorch]
if [ $? -ne 0 ]; then
    echo "[ERROR] Installing Horovod Failed!"
    exit
fi

# There is somthing wrong with pillow-simd
# use the faster pillow-simd instead of the original pillow
# https://github.com/uploadcare/pillow-simd

pip install -U 'spacy[cuda111]' 
if [ $? -ne 0 ]; then
    echo "[ERROR] Installing Spacy Failed!"
    exit
fi
# python -m spacy download en_core_web_sm
pip install /data/private/yangguang/MEE/en_core_web_sm-3.2.0.tar.gz
if [ $? -ne 0 ]; then
    echo "[ERROR] Downloading Spacy Model Failed!"
    exit
fi
# If timed out, download model manually

pip install -r requirements.txt
if [ $? -ne 0 ]; then
    echo "[ERROR] Installing requirements Failed!"
    exit
fi

#git clone https://github.com/NVIDIA/apex.git &&\
#    cd apex
cp -r /data/private/yangguang/MEE/apex ./apex && cd apex
if [ $? -ne 0 ]; then
    echo "[ERROR] Cloning Apex Failed!"
    exit
fi
# If timed out, download apex manually

pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" . &&\
rm -rf ../apex
if [ $? -ne 0 ]; then
    echo "[ERROR] Installing Apex Failed!"
    exit
fi