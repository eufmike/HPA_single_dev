import pandas as pd
from pathlib import Path

configfile: "./smconfig.yaml"

print("Config start")
print(config)
print("Config end")

df = pd.read_csv(Path(config['img_ipdir']).joinpath('train.csv'))
# df = df[:25]
idlist = df['ID'].tolist()

# OPFOLDER = 'train_rgb_c210_25_merge'
# OPCSVALL = 'all_25_merge.csv'
OPFOLDER = 'train_rgb_c210_merge'
OPCSVALL = 'all_merge.csv'

rule all:
    input:
        csv = Path(config['img_opdir'], OPCSVALL),
        # data_npy = expand(Path(config['img_opdir'], OPFOLDER, 'seg', '{imgid}_seg.npy'), imgid = idlist),
        # masks_png = expand(Path(config['img_opdir'], OPFOLDER, 'seg', '{imgid}_cp_masks.png'), imgid = idlist), 
        # outlines_txt = expand(Path(config['img_opdir'], OPFOLDER, 'seg', '{imgid}_cp_outlines.txt'), imgid = idlist), 
        # output_png = expand(Path(config['img_opdir'], OPFOLDER, 'seg', '{imgid}_cp_output.png'), imgid = idlist),

rule convert:
    message: "Rule {rule} processing"
    threads: config['max-thread']
    # input:
    conda: 
        "mspytorch"
    params:
        ipdir = Path(config["img_ipdir"], 'train'), 
        imgid = "{imgid}"
    output:
        img = Path(config["img_opdir"], OPFOLDER, "img", "{imgid}.png"),
        csv = Path(config["img_opdir"], OPFOLDER, "csv", "{imgid}.csv")
    shell:
        f"python {Path(config['script_dir'], 'channel_merge.py')}" + \
        " -i {params.ipdir} -id {params.imgid} " + \
        " -o {output.img} -c {output.csv}"

rule merge:
    message: "Rule {rule} processing"
    threads: config['max-thread']
    conda:
        "mspytorch"
    input:
        img = expand(Path(config['img_opdir'], OPFOLDER, 'img', '{imgid}.png'), imgid = idlist), 
        csv = expand(Path(config['img_opdir'], OPFOLDER, 'csv', '{imgid}.csv'), imgid = idlist)
    output:
        csv = Path(config['img_opdir'], OPCSVALL)
    shell:
        f"python {Path(config['script_dir'], 'merge_csv.py')}" + \
        " -i {input.csv} -o {output.csv} "

rule cellpose:
    message: "Rule {rule} processing"
    threads: config['max-thread']
    conda:
        "mscp03"
    input:
        # img = expand(Path(config['img_opdir'], OPFOLDER, 'img', '{imgid}.png'), imgid = idlist), 
    output:
        data_npy = expand(Path(config['img_opdir'], OPFOLDER, 'seg', '{imgid}_seg.npy'), imgid = idlist),
        # masks_png = expand(Path(config['img_opdir'], OPFOLDER, 'seg', '{imgid}_cp_masks.png'), imgid = idlist), 
        # outlines_txt = expand(Path(config['img_opdir'], OPFOLDER, 'seg', '{imgid}_cp_outlines.txt'), imgid = idlist), 
        # output_png = expand(Path(config['img_opdir'], OPFOLDER, 'seg', '{imgid}_cp_output.png'), imgid = idlist),
    params:
        img = Path(config['img_opdir'], OPFOLDER, 'img' ), 
        g_device = 0,
        batch_size = 512
    shell:
        f"python {Path(config['script_dir'], 'cellpose_seg.py')}" + \
        " -i {params.img} " + f"-o {Path(config['img_opdir'], OPFOLDER, 'seg')}" + \
        " -g {params.g_device} -b {params.batch_size}"    

    