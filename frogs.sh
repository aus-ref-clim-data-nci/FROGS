#!/bin/bash
# =============================================================================
#
# Copyright 2021 ARC Centre of Excellence for Climate Extremes 
# Copyright 2026 ARC Centre of Excellence for Weather of the 21st Century
# 
# author of initial python script: Paola Petrelli <paola.petrelli@utas.edu.au>
# author of bash version: Samuel Green <sam.green@unsw.edu.au>
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================
# Download FROGs 1DD_V2 from IPSL FTP preserving subdirectory structure
# Source: ftp://ftp.climserv.ipsl.polytechnique.fr/FROGs/1DD_V2/
# Target: /g/data/jt48/aus-ref-clim-data-nci/frogs/data/1DD_V2/
# ==============================================================================

FTP_URL="ftp://ftp.climserv.ipsl.polytechnique.fr/FROGs/1DD_V2/"
LOCAL_BASE="/g/data/jt48/aus-ref-clim-data-nci/frogs/data/1DD_V2"
LOGFILE="/g/data/jt48/aus-ref-clim-data-nci/frogs/code/update_log.txt"

mkdir -p "${LOCAL_BASE}"
cd "${LOCAL_BASE}" || { echo "ERROR: cannot cd to ${LOCAL_BASE}"; exit 1; }

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting FROGs 1DD_V2 mirror" | tee -a "${LOGFILE}"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Source : ${FTP_URL}"           | tee -a "${LOGFILE}"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Target : ${LOCAL_BASE}"        | tee -a "${LOGFILE}"

wget \
    --recursive \
    --level=inf \
    --no-parent \
    --no-clobber \
    --no-host-directories \
    --cut-dirs=2 \
    --passive-ftp \
    --tries=3 \
    --timeout=60 \
    --retry-connrefused \
    --progress=dot:giga \
    --append-output="${LOGFILE}" \
    "${FTP_URL}"

EXIT_CODE=$?

if [[ ${EXIT_CODE} -eq 0 ]]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Mirror complete" | tee -a "${LOGFILE}"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] wget exited with code ${EXIT_CODE} -- check log for failures" | tee -a "${LOGFILE}"
fi